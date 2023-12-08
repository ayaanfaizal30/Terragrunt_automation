variable "environment" {
  description = "Environment"
  type        = string
}

variable "cidr" {
  description = "CIDR block of the VPC"
  type        = string
}

variable "aws_region" {
  type        = string
  description = "Region in which the VPC will be created"
  nullable    = false
}