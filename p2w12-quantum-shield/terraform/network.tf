cat > network.tf << 'EOF'
# VPC Configuration
resource "aws_vpc" "quantum_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "quantum-shield-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "quantum_igw" {
  vpc_id = aws_vpc.quantum_vpc.id
  
  tags = {
    Name = "quantum-shield-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.quantum_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  
  tags = {
    Name = "quantum-shield-public-subnet"
    Tier = "Public"
  }
}

# Private App Subnet
resource "aws_subnet" "private_app_subnet" {
  vpc_id            = aws_vpc.quantum_vpc.id
  cidr_block        = var.private_app_subnet_cidr
  availability_zone = var.availability_zone
  
  tags = {
    Name = "quantum-shield-private-app-subnet"
    Tier = "Private-App"
  }
}

# Private Data Subnet
resource "aws_subnet" "private_data_subnet" {
  vpc_id            = aws_vpc.quantum_vpc.id
  cidr_block        = var.private_data_subnet_cidr
  availability_zone = var.availability_zone
  
  tags = {
    Name = "quantum-shield-private-data-subnet"
    Tier = "Private-Data"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.quantum_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.quantum_igw.id
  }
  
  tags = {
    Name = "quantum-shield-public-rt"
  }
}

# Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.quantum_vpc.id
  
  tags = {
    Name = "quantum-shield-private-rt"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_app_rta" {
  subnet_id      = aws_subnet.private_app_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_data_rta" {
  subnet_id      = aws_subnet.private_data_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
