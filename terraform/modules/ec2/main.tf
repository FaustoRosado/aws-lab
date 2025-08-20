# Key Pair for SSH access
resource "aws_key_pair" "lab_key" {
  key_name   = var.key_pair_name
  public_key = file("${path.module}/ssh/lab-key.pub")
}

# Public EC2 Instance (Web Server - Target for compromise simulation)
resource "aws_instance" "public_web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name              = aws_key_pair.lab_key.key_name
  subnet_id             = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_ids.public_ec2]

  user_data = base64encode(templatefile("${path.module}/user_data/web_server.sh", {
    environment = var.environment
  }))

  # Optimize for fast termination - cybersecurity professionals need speed
  disable_api_termination = false
  instance_initiated_shutdown_behavior = "terminate"

  tags = {
    Name        = "${var.environment}-public-web-server"
    Environment = var.environment
    Purpose     = "Web Server - Compromise Target"
  }
}

# Private EC2 Instance (Database/Internal Server)
resource "aws_instance" "private_db" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name              = aws_key_pair.lab_key.key_name
  subnet_id             = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_ids.private_ec2]

  user_data = base64encode(templatefile("${path.module}/user_data/database_server.sh", {
    environment = var.environment
  }))

  # Optimize for fast termination - cybersecurity professionals need speed
  disable_api_termination = false
  instance_initiated_shutdown_behavior = "terminate"

  tags = {
    Name        = "${var.environment}-private-db-server"
    Environment = "lab"
    Purpose     = "Database Server - Internal Target"
  }
}

# Data source for Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
