resource "aws_vpc" "main" { # Main VPC for the infra
  cidr_block = var.vpc_cidr # Uses the variable vpc_cidr defined in variables.tf in the same module

  tags = merge(
    local.common_tags, # Uses common_tags block defined in locals.tf
    {
    Name = "Main-VPC"
    }
  )
}

resource "aws_subnet" "public" { # Public subnet for the instance
  vpc_id = aws_vpc.main.id 
  cidr_block = cidrsubnet(var.vpc_cidr, 8, var.subnet_index)
  availability_zone = var.availability_zone # Uses the variable availability_zone defined in variables.tf in the same module
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
    Name = "Main-Public-Subnet"
    }
  )
}

resource "aws_internet_gateway" "main_IGW" { # Main Internet Gateway for the VPC
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
    Name = "Main-IGW"
    }
  ) 
}

resource "aws_route_table" "main_RT" { # Main Route table for the VPC
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_IGW.id
  }

  tags = merge(
    local.common_tags,
    {
    Name = "Main-RT"
    }
  )
}

resource "aws_route_table_association" "main_RTA" { # Associating the Route table to the subnet
  subnet_id = aws_subnet.public.id # Associating the Route table to the subnet
  route_table_id = aws_route_table.main_RT.id
}

resource "aws_security_group" "main_SG" {
  name = "main-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow SSH to instance"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
    Name = "Main-SG"
    }
  )
}