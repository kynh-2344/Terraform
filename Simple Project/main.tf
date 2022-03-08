provider "aws" {}

resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
      Name = "my-vpc"
  }
}

data "aws_ami" "public_instance_data"{
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-*-ebs"]
    }
    filter {
        name = "architecture"
        values = ["x86_64"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
    filter {
        name = "hypervisor"
        values = ["xen"]
    }
    filter {
        name = "image-type"
        values = ["machine"]
    }
}

resource "aws_instance" "public_instance" {
  ami = data.aws_ami.public_instance_data.id
  instance_type = "t2.micro"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.public_nic.id
  }
  key_name = "aws-key"
  tags = {
      Name = "Public-EC2"
  }
  user_data = <<-EOF
              #!/bin/sh
              yum -y install httpd php telnet
              chkconfig httpd on
              cd /var/www/html
              wget https://us-west-2-aws-training.s3.amazonaws.com/awsu-spl/spl03-working-elb/static/examplefiles-elb.zip
              unzip examplefiles-elb.zip
              /usr/sbin/httpd -DFOREGROUND
              EOF
}

resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.custom_vpc.id
  map_public_ip_on_launch = true 
  tags = {
      Name = "Public-Subnet"
  }
}

resource "aws_internet_gateway" "custom_internet_gateway" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
      Name = "my-igw"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.custom_internet_gateway.id
  }
  tags = {
      Name = "Public-Route"
  }
}

resource "aws_route_table_association" "public_route_subnet" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route.id
}

resource "aws_security_group" "custom_sg" {
  name = "Public-SG"
  description = "Simbple SG"
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
      protocol = "tcp"
      from_port = 80
      to_port = 80
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      protocol = "tcp"
      from_port = 80
      to_port = 80
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      protocol = "tcp"
      from_port = 443
      to_port = 443
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "Public-SG"
  }
}

resource "aws_network_acl" "custom_acl" {
  vpc_id = aws_vpc.custom_vpc.id
  subnet_ids = [
      aws_subnet.public_subnet.id
  ]
  ingress {
      protocol = "tcp"
      rule_no = 100
      from_port = 22
      to_port = 22
      action = "allow"
      cidr_block = "0.0.0.0/0"
  }
  ingress {
      protocol = "tcp"
      rule_no = 110
      from_port = 80
      to_port = 80
      action = "allow"
      cidr_block = "0.0.0.0/0"
  }
  ingress {
      protocol = "tcp"
      rule_no = 120
      from_port = 1024
      to_port = 65535
      cidr_block = "0.0.0.0/0"
      action = "allow"
  }
  egress {
      rule_no = 100
      protocol = "tcp"
      from_port = 80
      to_port = 80
      action = "allow"
      cidr_block = "0.0.0.0/0"
  }
  egress {
      rule_no = 110
      protocol = "tcp"
      from_port = 443
      to_port = 443
      action = "allow"
      cidr_block = "0.0.0.0/0"
  }
  egress {
      rule_no = 120
      protocol = "tcp"
      from_port = 22
      to_port = 22
      action = "allow"
      cidr_block = "0.0.0.0/0"
  }
  egress {
      protocol = "tcp"
      rule_no = 130
      from_port = 1024
      to_port = 65535
      action = "allow"
      cidr_block = "0.0.0.0/0"
  }
  tags = {
      Name = "my-nacl"
  }
}

resource "aws_network_interface" "public_nic" {
  subnet_id = aws_subnet.public_subnet.id
  private_ips = ["10.0.1.77"]
  security_groups = [
      aws_security_group.custom_sg.id
  ]
}


