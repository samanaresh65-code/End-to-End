variable "ami" {
  type        = string
  default     = "ami-068c0051b15cdb816"
  description = "Default AMI for AWS"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
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
