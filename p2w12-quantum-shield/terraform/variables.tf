variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_app_subnet_cidr" {
  description = "CIDR block for private app subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_data_subnet_cidr" {
  description = "CIDR block for private data subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone" {
  description = "Availability zone for subnets"
  type        = string
  default     = "us-east-1a"
}

variable "kali_ami" {
  description = "AMI ID for Kali Linux instance"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2 (we'll update this)
}

variable "vuln_ami" {
  description = "AMI ID for vulnerable target instance"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2
}

variable "instance_type_kali" {
  description = "EC2 instance type for Kali Linux"
  type        = string
  default     = "t2.medium"
}

variable "instance_type_vuln" {
  description = "EC2 instance type for vulnerable target"
  type        = string
  default     = "t2.micro"
}

variable "my_ip" {
  description = "Your personal IP address for SSH access (CIDR notation)"
  type        = string
  default     = "162.84.199.50/32" # We'll update this
}
