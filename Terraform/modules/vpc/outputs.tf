output "vpc_id" {
  value       = aws_vpc.myvpc.id
  description = "Default VPC id"
}

output "public_subnet_id" {
  value       = aws_subnet.mypublicsubnet.id
  description = "Public Subnet 1 ID (AZ1)"
}

output "public_subnet_2_id" {
  value       = aws_subnet.mypublicsubnet2.id
  description = "Public Subnet 2 ID (AZ2)"
}

output "private_subnet_id" {
  value       = aws_subnet.myprivatesubnet.id
  description = "Private Subnet 1 ID (AZ1)"
}

output "private_subnet_2_id" {
  value       = aws_subnet.myprivatesubnet2.id
  description = "Private Subnet 2 ID (AZ2)"
}

output "igw_id" {
  value       = aws_internet_gateway.myigw.id
  description = "Default internet gateway id"
}

output "security_group_id" {
  value       = aws_security_group.mysecuritygroup.id
  description = "Security group ID"
}
