# providers.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Use a compatible version
    }
  }
}

provider "aws" {
  region = var.aws_region
}
