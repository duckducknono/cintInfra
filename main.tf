terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"

  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  newbits              = var.newbits
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count
  tags                 = local.tags
}

module "app" {
  source = "./modules/app"

  name       = var.name
  aws_region = var.aws_region
  tags       = local.tags

  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  instance_type        = var.instance_type
  asg_min_size         = var.asg_min_size
  asg_max_size         = var.asg_max_size
  asg_desired_capacity = var.asg_desired_capacity
  page_variable_value  = var.page_variable_value
  page_secret_value    = var.page_secret_value
}
