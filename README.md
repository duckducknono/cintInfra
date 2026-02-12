# Infra deployment exercise

![diagram](./images/diagram.png)

Quick demo infra to show how I'd wire this up.

## Before you start

Pick a region and verify caller identity first:

```bash
# optional if you use named profiles:
export AWS_PROFILE=CintInfra
export AWS_DEFAULT_REGION=eu-west-2
aws sts get-caller-identity
```

You need:
- AWS creds for the target account
- region set (`AWS_DEFAULT_REGION` or `AWS_REGION`)
- a globally unique lowercase S3 bucket name for Terraform state (no `< >` placeholders)

## What it builds

- VPC + subnets + routing
- ALB on port 80
- ASG with `2 x t2.nano` (Ubuntu 24.04)
- nginx page on boot with:
  - a mock RDS connection string
  - demo values
  - a random dad joke

Code is split into:
- `modules/network`
- `modules/app`

## A few assumptions

- This assumes a fairly vanilla AWS account setup (standard IAM permissions, no unusual SCP/Org guardrails, normal service quotas).
- DB is mocked on purpose (no real RDS resource)
- Single NAT gateway to keep it simple
- Joke is fetched at instance boot, so refresh does not pull a new API joke on the same instance (but with multiple instances behind the ALB you might still see a different joke between requests)

## 1) Bootstrap backend with CloudFormation (optional helper)

If you want a quick backend bootstrap, use:
- `cloudformation/github-oidc-terraform-role.yml`

```bash
STACK_NAME=CintInfra-bootstrap
TF_STATE_BUCKET=cintinfra-terraform-state-123456789012-001

aws cloudformation deploy \
  --stack-name "$STACK_NAME" \
  --template-file cloudformation/github-oidc-terraform-role.yml \
  --parameter-overrides \
    TfStateBucketName="$TF_STATE_BUCKET" \
    TfLockTableName="CintInfra-terraform-locks"
```

Grab backend values:

```bash
aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query "Stacks[0].Outputs[*].[OutputKey,OutputValue]" \
  --output table
```

Helper to export backend env vars from that stack:

```bash
eval "$(
  aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --query "Stacks[0].Outputs[].[OutputKey,OutputValue]" \
    --output text | awk '
      $1=="TfStateBucketOut" {print "export TF_STATE_BUCKET="$2}
      $1=="TfLockTableOut"   {print "export TF_LOCK_TABLE="$2}
      $1=="AwsRegionOut"     {print "export AWS_REGION="$2}
    '
)"
export TF_STATE_KEY="${TF_STATE_KEY:-cintinfra/terraform.tfstate}"
```

Use:
- `TfStateBucketOut` -> `TF_STATE_BUCKET`
- `TfLockTableOut` -> `TF_LOCK_TABLE`
- `AwsRegionOut` -> `AWS_REGION`

## 2) Deploy (local Terraform)

```bash
terraform init \
  -reconfigure \
  -backend-config="bucket=$TF_STATE_BUCKET" \
  -backend-config="key=$TF_STATE_KEY" \
  -backend-config="region=$AWS_REGION" \
  -backend-config="dynamodb_table=$TF_LOCK_TABLE"

terraform apply -auto-approve
```

Get the URL:

```bash
terraform output -raw alb_dns_name
```

Open `http://<alb_dns_name>/`.

## About the GitHub workflows

Workflows are included as examples of how I’d usually wire CI/CD:
- `.github/workflows/terraform.yml`
- `.github/workflows/iac-security.yml`
- `.github/workflows/iac-checkov.yml`

They are not required to run this locally. If you do use `terraform.yml`,
it expects classic AWS secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`),
not OIDC role assumption.

## Notes from the brief

How would another app get the ALB DNS?
- easiest: use Terraform output `alb_dns_name`
- better long-term: publish to SSM or front it with Route53

What matters for CD / production safety?
- remote state + locking
- plan/apply split + approvals
- least-privilege IAM
- PR checks + protected branches + smoke tests

## Cleanup

Destroy Terraform infra:

```bash
terraform destroy -auto-approve
```

Delete bootstrap stack (if you created it):

```bash
STACK_NAME=CintInfra-bootstrap
aws cloudformation delete-stack --stack-name "$STACK_NAME"
if ! aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME"; then
  TF_STATE_BUCKET=$(aws cloudformation describe-stack-resources \
    --stack-name "$STACK_NAME" \
    --query "StackResources[?LogicalResourceId=='TfStateBucket'].PhysicalResourceId" \
    --output text)

  if [ -n "$TF_STATE_BUCKET" ] && [ "$TF_STATE_BUCKET" != "None" ]; then
    aws s3api delete-objects --bucket "$TF_STATE_BUCKET" --delete "$(
      aws s3api list-object-versions --bucket "$TF_STATE_BUCKET" --output json \
      | jq '{Objects: ([.Versions[]?, .DeleteMarkers[]?] | map({Key: .Key, VersionId: .VersionId})), Quiet: true}'
    )" || true
    aws s3 rm "s3://$TF_STATE_BUCKET" --recursive || true
    aws s3api delete-bucket --bucket "$TF_STATE_BUCKET" || true
  fi

  aws cloudformation delete-stack --stack-name "$STACK_NAME" --deletion-mode FORCE_DELETE_STACK
  aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME"
fi
```
