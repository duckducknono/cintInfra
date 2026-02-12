variable "name" {
  type        = string
  default     = "CintInfra"
  description = "Root name for resources in this project"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy into"
}

variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "VPC cidr block"
}

variable "newbits" {
  default     = 8
  type        = number
  description = "How many bits to extend the VPC cidr block by for each subnet"
}

variable "public_subnet_count" {
  default     = 3
  type        = number
  description = "How many subnets to create"
}

variable "private_subnet_count" {
  default     = 3
  type        = number
  description = "How many private subnets to create"
}

variable "instance_type" {
  type        = string
  default     = "t2.nano"
  description = "EC2 instance type for the Auto Scaling Group"
}

variable "asg_min_size" {
  type        = number
  default     = 2
  description = "ASG minimum size"
}

variable "asg_max_size" {
  type        = number
  default     = 2
  description = "ASG maximum size"
}

variable "asg_desired_capacity" {
  type        = number
  default     = 2
  description = "ASG desired capacity"
}

variable "page_variable_value" {
  type        = string
  default     = ""
  description = "Optional value to render on the nginx page (typically from a GitHub variable via TF_VAR_page_variable_value)."
}

variable "page_secret_value" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Optional value to render on the nginx page (typically from a GitHub secret via TF_VAR_page_secret_value)."
}
