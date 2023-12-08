include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//modules/vpc"
}

locals {
  input_vars = read_terragrunt_config(find_in_parent_folders("input_vars.hcl"))
}

inputs = {
  environment = local.input_vars.locals.environment
  cidr        = local.input_vars.locals.vpc.cidr
}