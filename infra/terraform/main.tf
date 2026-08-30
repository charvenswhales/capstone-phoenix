terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "capstone-phoenix-tfstate"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "capstone-phoenix-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source       = "./modules/network"
  project_name = var.project_name
}

module "security_group" {
  source       = "./modules/security_group"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  my_ip        = var.my_ip
}

module "compute" {
  source            = "./modules/compute"
  project_name      = var.project_name
  subnet_id         = module.network.subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = var.key_name
  instance_type     = var.instance_type
  ami_id            = var.ami_id
}
