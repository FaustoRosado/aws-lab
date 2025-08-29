# Quantum Shield Cyber Range - P2W12 Final Project
# Team: Shannon Kelly, Fausto Rosado, Zeinab Ali, Latrisha Dodson, Javier Acosta

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
      Project     = "Quantum-Shield-Cyber-Range"
      Team        = "P2W12"
      Environment = "Lab"
      ManagedBy   = "Terraform"
      Purpose     = "Cybersecurity Training"
    }
  }
}
