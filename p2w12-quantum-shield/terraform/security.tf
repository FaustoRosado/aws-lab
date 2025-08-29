# Security Group for Kali Linux Attacker
resource "aws_security_group" "kali_sg" {
  name        = "quantum-shield-kali-sg"
  description = "Security group for Kali Linux attacker instance"
  vpc_id      = aws_vpc.quantum_vpc.id
  
  # SSH access from your IP only
  ingress {
    description = "SSH from your IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  
  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "quantum-shield-kali-sg"
    Purpose = "Attacker"
  }
}

# Security Group for Vulnerable Target
resource "aws_security_group" "vuln_sg" {
  name        = "quantum-shield-vuln-sg"
  description = "Security group for vulnerable target instance"
  vpc_id      = aws_vpc.quantum_vpc.id
  
  # HTTP access from anywhere
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # SSH access from Kali instance only
  ingress {
    description = "SSH from Kali instance"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.kali_sg.id]
  }
  
  # ICMP (ping) from Kali instance only
  ingress {
    description = "ICMP from Kali instance"
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.kali_sg.id]
  }
  
  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "quantum-shield-vuln-sg"
    Purpose = "Target"
  }
}

# Network ACL for Public Subnet
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.quantum_vpc.id
  
  # Allow all inbound traffic
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  
  # Allow all outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  
  tags = {
    Name = "quantum-shield-public-nacl"
  }
}

# Network ACL Association
resource "aws_network_acl_association" "public_nacl_assoc" {
  network_acl_id = aws_network_acl.public_nacl.id
  subnet_id      = aws_subnet.public_subnet.id
}
