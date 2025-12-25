variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Default cidr block for AWS"
}

variable "vpc_name" {
  type        = string
  description = "Default vpc name for AWS"
}

variable "public_subnet_cidr_block" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Default public subnet cidr block for AWS"
}

variable "private_subnet_cidr_block" {
  type        = string
  default     = "10.0.2.0/24"
  description = "Default private subnet cidr block for AWS"
}
