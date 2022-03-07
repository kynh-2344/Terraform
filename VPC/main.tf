provider "aws" {}

resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  #availability_zone = "us-east-1a"
  enable_dns_hostnames = true
  tags = {
      Name = "my-vpc"
  }
}

resource "aws_subnet" "private-sub" {
  vpc_id = aws_vpc.custom_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.1.0/24"
  tags = {
      Name = "Private-Subnet"
  }
}

resource "aws_subnet" "public-subnet" {
    vpc_id = aws_vpc.custom_vpc.id
    availability_zone = "us-east-1b"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    tags = {
      "Name" = "Public-Subnet"
    }
}