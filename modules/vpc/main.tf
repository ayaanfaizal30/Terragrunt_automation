locals {
  azs = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.environment}_VPC"
  cidr = var.cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.cidr, 4, k + 4)]
  database_subnets  = [for k, v in local.azs : cidrsubnet(var.cidr, 4, k + 8)]
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  create_database_subnet_group  = true
  manage_default_network_acl    = false
  manage_default_route_table    = false
  manage_default_security_group = false

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true
}
