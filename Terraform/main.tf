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
    key            = "root/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = module.vpc.private_subnet_id
  security_group_id = module.vpc.security_group_id
  instance_name     = "my-devops-ec2"
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "my-devops-vpc"
}

module "eks" {
  source     = "./modules/eks"
  subnet_ids = [module.vpc.private_subnet_id, module.vpc.private_subnet_2_id]
}


module "ecr" {
  source          = "./modules/ecr"
  repository_name = "my-devops-ecr"
  max_image_count = 1
}


