// security_groups.tf - Security Groups

// Purpose: Defines the security groups for your application.
// This file centralizes firewall rules to control traffic to and from
// your EC2 instances.

// Security group for the web server
resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg"
  description = "Allow inbound traffic for web servers"
  vpc_id      = aws_vpc.main.id

  // Allows inbound SSH traffic from anywhere (for demonstration)
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allows inbound HTTP traffic from anywhere
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Allows all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform Web Server SG"
  }
}

// Security group for the application server
resource "aws_security_group" "app_server_sg" {
  name        = "app-server-sg"
  description = "Allow inbound traffic from web servers"
  vpc_id      = aws_vpc.main.id

  // Allows inbound traffic from the web server security group
  ingress {
    description = "Allow traffic from Web Server SG"
    from_port   = 8080 // Example application port
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.web_server_sg.id]
  }

  // Allows outbound traffic to the database
  egress {
    description = "Allow traffic to DB"
    from_port   = 3306 // MySQL default port
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.db_security_group.id]
  }

  // Allows all other outbound traffic to the internet via NAT Gateway
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform App Server SG"
  }
}
