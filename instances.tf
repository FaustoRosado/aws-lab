// instances.tf - EC2 Instances

// Purpose: Defines the EC2 instances for your application.
// This file separates the server definitions from the network and security configurations.

// Data source to find the latest Ubuntu 22.04 LTS AMI.
// Using a data source is a best practice to avoid hard-coding AMI IDs.
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] // Canonical's owner ID
}

// Creates the Web Server instance in a public subnet
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.public.*.id, 0)
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  // A basic script to install Apache and create a simple web page on launch
  user_data = <<-EOT
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<h1>Hello from your Terraform-provisioned Web Server!</h1>" | sudo tee /var/www/html/index.html
              EOT

  tags = {
    Name = "Terraform-Web-Server"
  }
}

// Creates the Application Server instance in a private subnet
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.private.*.id, 0)
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]

  tags = {
    Name = "Terraform-App-Server"
  }
}
