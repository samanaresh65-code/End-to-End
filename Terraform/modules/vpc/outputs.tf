output "vpc_id" {
  value       = aws_vpc.myvpc.id
  description = "Default VPC id"
}

output "public_subnet_id" {
  value       = aws_subnet.mypublicsubnet.id
  description = "Default public subnet id"
}

output "private_subnet_id" {
  value       = aws_subnet.myprivatesubnet.id
  description = "Default private subnet id"
}

output "igw_id" {
  value       = aws_internet_gateway.myigw.id
  description = "Default internet gateway id"
}

output "rt_id" {
  value       = aws_route_table.myrt.id
  description = "Default route table id"
}

output "security_group_id" {
  value       = aws_security_group.mysecuritygroup.id
  description = "Security group ID"
}

