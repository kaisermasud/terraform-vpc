# Create a vpc. You can copy the code block from google typing 
# resource "aws_vpc"

resource "aws_vpc" "vpc" {
  cidr_block       = "var.vpc_cidr"
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Create an internet gateway and attach it to the vpc

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}
# use data source to get all availablity zones in region
data "aws_availability_zones" "available_zone" {
}

# Create a public subnet in az1

resource "aws_subnet" "public_subnet_az1" {
  vpc_id       = aws_vpc.vpc.id
  cidr_block   = var.public_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az1"
  }

  # ...
}
# Create a public subnet in az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id       = aws_vpc.vpc.id
  cidr_block   = var.public_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "public subnet az2"
  }
}

# Create a route table and public route
resource "aws_route_table" "public_route_table" {
    vpc_id            = aws_vpc.vpc.id
    
    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.internet_gateway.id
    }
    tags    = {
        Name = "public route table"
    }
}

# Associate public subnet az1 to public route
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate public subnet az2 to public route
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a private app subnet in az1
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id       = aws_vpc.vpc.id
  cidr_block   = var.private_app_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name =  " private app subnet az1"
  }

  # ...
}
# Create a private subnet in az2
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id       = aws_vpc.vpc.id
  cidr_block   = var.private_app_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "private app subnet az2"
  }
}

# create private data subnet in az1

resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id       = aws_vpc.vpc.id
  cidr_block   = var.private_data_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "private data subnet az1"
  }
}
# create private data subnet in az1

resource "aws_subnet" "public_data_subnet_az2" {
  vpc_id       = aws_vpc.vpc.id
  cidr_block   = var.private_data_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.available_zone.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "private data subnet az2"
  }
}