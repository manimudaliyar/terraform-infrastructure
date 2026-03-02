# ---------------------------------------
# Networking Module
# Creates:
# - VPC
# - Public Subnet
# - Internet Gateway
# - Route Table
# - Security Group
#
# Outputs:
# - vpc_id
# - subnet_id
# - security_group_id
#
# Applies:
# - Standardized tagging via local.common_tags
# ---------------------------------------
resource "aws_vpc" "main" { # Main VPC for the infra
  cidr_block = var.vpc_cidr # Uses the variable vpc_cidr defined in variables.tf in the same module

  tags = merge(
    local.common_tags, # Uses common_tags block defined in locals.tf
    {
    Name = "${var.environment}-VPC"
    }
  )
}

resource "aws_subnet" "public" { # Public subnet for the instance
  vpc_id = aws_vpc.main.id 
  cidr_block = cidrsubnet(var.vpc_cidr, 8, var.subnet_index)
  availability_zone = var.availability_zone # Uses the variable availability_zone defined in variables.tf in the same module
  map_public_ip_on_launch = true # Automatically assigns a public IP to instances launched in this subnet

  tags = merge(
    local.common_tags,
    {
    Name = "${var.environment}-Public-Subnet"
    }
  )
}

resource "aws_internet_gateway" "main_IGW" { # Main Internet Gateway for the VPC
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
    Name = "${var.environment}-IGW"
    }
  ) 
}

resource "aws_route_table" "main_RT" { # Main Route table for the VPC
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" # Route for all outbound traffic to the Internet Gateway
    gateway_id = aws_internet_gateway.main_IGW.id 
  }

  tags = merge(
    local.common_tags,
    {
    Name = "${var.environment}-RT"
    }
  )
}

resource "aws_route_table_association" "main_RTA" { # Associating the Route table to the subnet
  subnet_id = aws_subnet.public.id # Associating the Route table to the subnet
  route_table_id = aws_route_table.main_RT.id
}

resource "aws_security_group" "main_SG" {
  name = "main-sg" # Name of the security group
  vpc_id = aws_vpc.main.id # Associating the security group to the VPC

  ingress { # Ingress rule to allow SSH to the instance
    description = "Allow SSH to instance"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress { # Egress rule to allow all outbound traffic from the instance
    description = "Outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
    Name = "${var.environment}-SG"
    }
  )
}