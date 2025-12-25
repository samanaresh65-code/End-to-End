terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
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
  subnet_ids = [module.vpc.private_subnet_id, module.vpc.public_subnet_id]
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = "my-devops-ecr"
  max_image_count = 1
}


