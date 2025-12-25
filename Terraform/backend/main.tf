# backend/main.tf
terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-bucket-sama"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform-bucket-sama" {
  bucket = "terraform-bucket-sama"
}

resource "aws_s3_bucket_versioning" "terraform-bucket-sama-versioning" {
  bucket = aws_s3_bucket.terraform-bucket-sama.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform-bucket-sama-acl" {
  bucket                  = aws_s3_bucket.terraform-bucket-sama.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB setup     

resource "aws_dynamodb_table" "terraform-state-locks" {
  name     = "terraform-state-locks"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}



