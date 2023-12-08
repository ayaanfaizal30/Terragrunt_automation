variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the instance will be created"
  type        = string
}

variable "iam_instance_profile" {
  description = "The IAM instance profile to attach to the instance"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to be used for the EC2 instance"
  type        = string
}