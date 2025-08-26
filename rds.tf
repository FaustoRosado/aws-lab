// rds.tf - RDS Database Configuration

// This file creates a MySQL database instance in the private subnets
// of your network. Placing the database in a private subnet is a
// critical security measure to prevent direct internet access.

// Creates a DB subnet group from your private subnets. This is required
// for RDS instances to be deployed in your VPC.
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

// Creates a security group for the RDS database. This security group
// will only allow inbound connections from the application servers,
// enforcing the principle of least privilege.
resource "aws_security_group" "db_security_group" {
  name        = "db-security-group"
  description = "Allow inbound traffic from application servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Allow app server access"
    from_port       = 3306 // MySQL default port
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["10.0.3.0/24", "10.0.4.0/24"] // CIDRs for your private subnets
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS DB Security Group"
  }
}

// Creates the RDS database instance.
resource "aws_db_instance" "my_db" {
  engine                  = "mysql"
  engine_version          = "8.0.37"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  skip_final_snapshot     = true
  publicly_accessible     = false
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.db_security_group.id]

  username = var.db_username
  password = var.db_password
}
