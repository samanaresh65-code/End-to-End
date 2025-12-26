data "aws_availability_zones" "available" {
  state = "available" # Only get AZs that are currently available in the region
}

resource "aws_vpc" "myvpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true # Required for EKS to register node names
  enable_dns_support   = true # Required for EKS to resolve domains
  tags = {
    Name = var.vpc_name
  }
}

# --- PUBLIC SUBNETS ---
# Used for: Load Balancers, NAT Gateway, Bastion Hosts.
# Why: Resources here have direct access to the Internet Gateway.

resource "aws_subnet" "mypublicsubnet" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true                                           # Instances get public IP automatically
  availability_zone       = data.aws_availability_zones.available.names[0] # AZ-1
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "mypublicsubnet2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.public_subnet_cidr_block_2
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1] # AZ-2
  tags = {
    Name = "public-subnet-2"
  }
}

# --- PRIVATE SUBNETS ---
# Used for: EKS Worker Nodes, Databases (RDS).
# Why: No direct internet access (more secure). Outbound traffic goes through NAT Gateway.

resource "aws_subnet" "myprivatesubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.private_subnet_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0] # AZ-1 (Match public subnet AZ)
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "myprivatesubnet2" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.private_subnet_cidr_block_2
  availability_zone = data.aws_availability_zones.available.names[1] # AZ-2 (Match public subnet AZ)
  tags = {
    Name = "private-subnet-2"
  }
}

# --- INTERNET GATEWAY ---
# The front door to the internet for the VPC.
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
}

# --- NAT GATEWAY CONFIGURATION ---
# Why: Private subnets need to download packages/updates but shouldn't accept incoming connections.
# NAT Gateway sits in a Public Subnet and forwards traffic from Private Subnets to the Internet.

# 1. Elastic IP for NAT Gateway (Static Public IP)
resource "aws_eip" "nat" {
  domain = "vpc"
}

# 2. The NAT Gateway Resource
resource "aws_nat_gateway" "mynat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.mypublicsubnet.id # MUST be in a Public Subnet to reach IGW

  tags = {
    Name = "my-nat-gateway"
  }

  # Ensure IGW exists first so we can reach the internet
  depends_on = [aws_internet_gateway.myigw]
}


# --- ROUTE TABLES ---

# 1. Public Route Table
# Traffic goes directly to Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

# 2. Private Route Table
# Traffic goes to NAT Gateway
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mynat.id # Point to NAT, not IGW
  }
  tags = {
    Name = "private-route-table"
  }
}

# --- ROUTE TABLE ASSOCIATIONS ---

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.mypublicsubnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.mypublicsubnet2.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.myprivatesubnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.myprivatesubnet2.id
  route_table_id = aws_route_table.private_rt.id
}


# --- SECURITY GROUP ---
resource "aws_security_group" "mysecuritygroup" {
  name        = "mysecuritygroup"
  description = "Allow SSH and outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  # Ingress: Allow SSH from anywhere (Use with caution in prod, typical for dev)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress: Allow all outbound traffic (Needed for downloading updates, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
