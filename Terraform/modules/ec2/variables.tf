variable "ami" {
  type        = string
  default     = "ami-00e428798e77d38d9"
  description = "Default AMI for AWS"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Default instance type for AWS"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID to launch instance in"
}
variable "security_group_id" {
  type        = string
  description = "Security group ID for the instance"
}

variable "instance_name" {
  type        = string
  description = "Instance name for the instance"
}
