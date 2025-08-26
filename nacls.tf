// Purpose: Defines stateless firewalls for your subnets.
// These NACLs provide a second layer of security in addition to security groups.

// Defines the NACL for the public subnets
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.main.id
  subnet_ids = aws_subnet.public[*].id
  tags = {
    Name = "public-nacl"
  }

  // Inbound Rules (Stateful)
  ingress {
    protocol = "tcp"
    rule_no  = 100
    action   = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol = "tcp"
    rule_no  = 110
    action   = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol = "tcp"
    rule_no  = 120
    action   = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  // Outbound Rules (Stateful)
  egress {
    protocol = "tcp"
    rule_no  = 100
    action   = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

// Defines the NACL for the private subnets
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.main.id
  subnet_ids = aws_subnet.private[*].id
  tags = {
    Name = "private-nacl"
  }

  // Inbound Rules (Stateless)
  ingress {
    protocol = "tcp"
    rule_no  = 100
    action   = "allow"
    cidr_block = element(var.public_subnet_cidrs, 0) // Allow SSH from public subnet 1
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol = "tcp"
    rule_no  = 110
    action   = "allow"
    cidr_block = element(var.public_subnet_cidrs, 1) // Allow SSH from public subnet 2
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol = "tcp"
    rule_no  = 120
    action   = "allow"
    cidr_block = "10.0.0.0/16" // Allow traffic from within the VPC
    from_port  = 0
    to_port    = 0
  }

  // Outbound Rules (Stateless)
  egress {
    protocol = "tcp"
    rule_no  = 100
    action   = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}
