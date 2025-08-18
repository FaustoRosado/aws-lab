# Security Group for Public EC2 Instances (Web Server)
resource "aws_security_group" "public_ec2" {
  name        = "${var.environment}-public-ec2-sg"
  description = "Security group for public EC2 instances"
  vpc_id      = var.vpc_id

  # SSH access
  ingress {
    description = "SSH from anywhere (for lab purposes)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-public-ec2-sg"
    Environment = var.environment
  }
}

# Security Group for Private EC2 Instances (Database/Internal)
resource "aws_security_group" "private_ec2" {
  name        = "${var.environment}-private-ec2-sg"
  description = "Security group for private EC2 instances"
  vpc_id      = var.vpc_id

  # SSH access from public subnets only
  ingress {
    description = "SSH from public subnets"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_blocks
  }

  # Database access from public subnets
  ingress {
    description = "MySQL from public subnets"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_blocks
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-private-ec2-sg"
    Environment = var.environment
  }
}

# Security Group for VPC Endpoints (if needed)
resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.environment}-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id

  # HTTPS access from VPC
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_blocks
  }

  tags = {
    Name        = "${var.environment}-vpc-endpoints-sg"
    Environment = var.environment
  }
}
