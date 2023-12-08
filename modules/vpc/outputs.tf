output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "database_subnet_group_name" {
  description = "database_subnet_group_name"
  value = module.vpc.database_subnet_group_name
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value = module.vpc.intra_subnets
}
