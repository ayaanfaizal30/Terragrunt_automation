include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../..//modules/jenkins"
}

dependency "vpc" {
  config_path = "../vpc"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available (e.g the
  # module hasn't been applied yet.
  mock_outputs = {
    vpc_id = "fake-vpc-id"
    private_subnets = ["172.101.0.0/16", "172.101.1.0/16", "172.101.2.0/16"],
    public_subnets = ["172.101.3.0/16", "172.101.4.0/16", "172.101.5.0/16"]
  }
}
inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
}

locals {
  input_vars = read_terragrunt_config(find_in_parent_folders("input_vars.hcl"))
}