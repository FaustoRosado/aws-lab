terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "EC2-Compromise-Lab"
      Environment = "Lab"
      Owner       = "Security Team"
      Purpose     = "Security Testing and Training"
    }
  }
}

# VPC and Networking
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  environment          = var.environment
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
}

# Security Groups
module "security_groups" {
  source = "./modules/security_groups"
  
  vpc_id = module.vpc.vpc_id
}

# EC2 Instances
module "ec2_instances" {
  source = "./modules/ec2"
  
  vpc_id                    = module.vpc.vpc_id
  public_subnet_ids         = module.vpc.public_subnet_ids
  private_subnet_ids        = module.vpc.private_subnet_ids
  security_group_ids        = module.security_groups.security_group_ids
  key_pair_name            = var.key_pair_name
  instance_type            = var.instance_type
  environment              = var.environment
}

# S3 Bucket for threat intelligence
module "s3_bucket" {
  source = "./modules/s3"
  
  bucket_name = var.s3_bucket_name
  environment = var.environment
}

# GuardDuty Configuration
module "guardduty" {
  source = "./modules/guardduty"
  
  environment = var.environment
}

# Security Hub Configuration
module "security_hub" {
  source = "./modules/security_hub"
  
  environment = var.environment
}

# CloudWatch Logs
module "cloudwatch" {
  source = "./modules/cloudwatch"
  
  environment = var.environment
  vpc_id     = module.vpc.vpc_id
}

# IAM Roles and Policies
module "iam" {
  source = "./modules/iam"
  
  environment = var.environment
}
