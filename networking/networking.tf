# the resources below are from main.tf for the modular constructs
# these make up the networking terraform module.

# modified so that it can be run by spacelift.
resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  # my addition for variable on aws_availability_zone based upon 
  # the spacelift linux vs. windows context (host_os)
  # see also variables.tf. The relevant contexts in spacelift have been updated
  # with the TF_VARS_aws_availability_zone ENV variable.  Linux is us-west-2a and
  # windows is us_east-1a. main test2.
  # availability_zone = "us-west-2a"
  availability_zone = var.aws_availability_zone


  tags = {
    Name = "dev-public"
  }
}


#Experimental subnet-1

resource "aws_subnet" "mtc_public_subnet-1" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.3.0/24"
  map_public_ip_on_launch = true
  # my addition for variable on aws_availability_zone based upon 
  # the spacelift linux vs. windows context (host_os)
  # see also variables.tf. The relevant contexts in spacelift have been updated
  # with the TF_VARS_aws_availability_zone ENV variable.  Linux is us-west-2a and
  # windows is us-west-2b.
  # availability_zone = "us-west-2a"
  availability_zone = "us-west-2c"

  # the us-east-1a zone must be used if the spacelift context is switched to windows-dev-east
  # because the aws_region is in us-east-1. You cannot create compute instances on aws_avaialbity_zones
  # that do not reside in the aws_region.  See main.tf as well.
  # availability_zone = "us-east-1a"
  #availability_zone = "us-east-1b"
  #availability_zone = "us-east-1c"
  # availability_zone = "us-east-1d"
  # availability_zone = "us-east-1e"
  #availability_zone = "us-east-1f"

  tags = {
    Name = "dev-public-1"
  }
}


resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "mtc_igw"
  }
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id
}

# need to also add aws_route_table_association for the subnet-1
resource "aws_route_table_association" "mtc_public_assoc-1" {
    subnet_id = aws_subnet.mtc_public_subnet-1.id
    route_table_id = aws_route_table.mtc_public_rt.id
}

resource "aws_security_group" "mtc_sg" {
  name        = "public_sg"
  description = "public security group"
  vpc_id      = aws_vpc.mtc_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}