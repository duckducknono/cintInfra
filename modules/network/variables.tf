variable "name" {
  type        = string
  description = "Root name for resources"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
}

variable "newbits" {
  type        = number
  description = "How many bits to extend the VPC cidr block by for each subnet"
}

variable "public_subnet_count" {
  type        = number
  description = "How many public subnets to create"
}

variable "private_subnet_count" {
  type        = number
  description = "How many private subnets to create"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}

