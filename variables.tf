// variables.tf - Project Variables

// Purpose: Declares all the configurable variables for the project.
// This file centralizes all input parameters, like CIDR blocks, names,
// and database credentials. This allows you to easily change values
// for different environments (e.g., dev, prod) without changing the code.

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  # A default value can be set here, e.g., default = "10.0.0.0/16"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

# This variable is for the list of public subnet CIDR blocks
variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

# This variable is for the list of private subnet CIDR blocks
variable "private_subnet_cidrs" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
}

# This variable is for the list of Availability Zones to deploy subnets into
variable "azs" {
  description = "A list of availability zones to create subnets in."
  type        = list(string)
}

// This file contains the new variables required for the S3, GuardDuty, and RDS configurations.

// New variables for the RDS database
variable "db_username" {
  description = "Username for the RDS database."
  type        = string
}

variable "db_password" {
  description = "Password for the RDS database."
  type        = string
  sensitive   = true
}

// New variable for the S3 bucket
variable "s3_bucket_name" {
  description = "The name for the S3 bucket."
  type        = string
}


// New variables for EC2 instances and SSH
variable "instance_type" {
  description = "The type of EC2 instance to create."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the SSH key pair to use for EC2 instances."
  type        = string
  default     = "WebServerKey"
}

variable "public_key_path" {
  description = "The path to the SSH public key file."
  type        = string
}
