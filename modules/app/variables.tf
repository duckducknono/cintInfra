variable "name" {
  type        = string
  description = "Root name for resources"
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy into (used for mock connection string only)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for the ALB"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the ASG"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the Auto Scaling Group"
}

variable "asg_min_size" {
  type        = number
  description = "ASG minimum size"
}

variable "asg_max_size" {
  type        = number
  description = "ASG maximum size"
}

variable "asg_desired_capacity" {
  type        = number
  description = "ASG desired capacity"
}

variable "page_variable_value" {
  type        = string
  default     = ""
  description = "Optional value to render on the nginx page."
}

variable "page_secret_value" {
  type        = string
  default     = ""
  sensitive   = true
  description = "Optional value to render on the nginx page."
}

