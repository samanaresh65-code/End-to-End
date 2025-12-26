output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_id
}

output "igw_id" {
  value = module.vpc.igw_id
}



output "security_group_id" {
  value = module.vpc.security_group_id
}

output "instance_id" {
  value = module.ec2.instance_id
}


