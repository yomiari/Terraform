terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "terraform-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "${var.env}-terraform-vpc"
  }
}

resource "aws_subnet" "terra-subnet" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = var.terra_subnet_cidr
  availability_zone = var.avail_zone
  tags = {
    Name : "${var.env}-subnet-1"
  }
}

/* data "aws_vpc" "default-vpc" {
  default = true
} */

resource "aws_subnet" "terra-subnet-2" {
  vpc_id            = aws_vpc.terraform-vpc.id
  cidr_block        = var.terra_subnet_2_cidr
  availability_zone = var.avail_zone
  tags = {
    Name : "${var.env}-subnet-2"
  }
}

resource "aws_route_table" "terra-rt" {
  vpc_id = aws_vpc.terraform-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }
  tags = {
    Name : "${var.env}-rt"
  }
}

resource "aws_internet_gateway" "terra_igw" {
  vpc_id = aws_vpc.terraform-vpc.id
  tags = {
    Name : "${var.env}-terra_igw"
  }
}

resource "aws_route_table_association" "terra-rta" {
  subnet_id      = aws_subnet.terra-subnet.id
  route_table_id = aws_route_table.terra-rt.id
}


resource "aws_route_table_association" "terra-rta-2" {
  subnet_id      = aws_subnet.terra-subnet-2.id
  route_table_id = aws_route_table.terra-rt.id
}

resource "aws_security_group" "terra-sg" {
  name   = "terra-sg"
  vpc_id = aws_vpc.terraform-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }


  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name : "${var.env}-terra_sg"
  }
}