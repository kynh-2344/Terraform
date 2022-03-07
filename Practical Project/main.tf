provider "aws" {}

resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
      Name = "my-vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.custom_vpc.id
  map_public_ip_on_launch = false
  tags = {
      Name = "Private-Subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.custom_vpc.id
  map_public_ip_on_launch = true
  tags = {
      Name = "Public-Subnet"
  }
}

resource "aws_internet_gateway" "custom_gateway" {
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
      Name = "my-igw"
  }
}

resource "aws_eip" "nat_eip" {
  depends_on = [
    aws_internet_gateway.custom_gateway
  ]
  vpc = true
}

resource "aws_nat_gateway" "custom_nat" {
  connectivity_type = "public"
  subnet_id = aws_subnet.public_subnet.id
  tags = {
      Name = "my-nat"
  }
  allocation_id = aws_eip.nat_eip.id
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.custom_gateway.id
  }
  tags = {
      Name = "Public-Route"
  }
}

resource "aws_route_table_association" "public_sub_route" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table" "private_subnet" {
  vpc_id = aws_vpc.custom_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.custom_nat.id
  }
  tags = {
      Name = "Private-Route"
  }
}

resource "aws_route_table_association" "private_sub_route" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_subnet.id
}

resource "aws_security_group" "bastion_sg" {
  name = "Bastion-SG"
  description = "Allow SSH From The Internet"
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
      Name = "Bastion-SG"
  }
}

resource "aws_network_acl" "custom_nacl" {
  vpc_id = aws_vpc.custom_vpc.id
  ingress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 80
    to_port = 80
  }
  ingress {
    protocol = "tcp"
    rule_no = 110
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
  }
  ingress {
    protocol = "tcp"
    rule_no = 120
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
  }
  ingress {
    protocol = "tcp"
    rule_no = 130
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
  }
  egress {
    protocol = "tcp"
    rule_no = 100
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 80
    to_port = 80
  }
  egress {
    protocol = "tcp"
    rule_no = 110
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 443
    to_port = 443
  }
  egress {
    protocol = "tcp"
    rule_no = 120
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
  }
  egress {
    protocol = "tcp"
    rule_no = 130
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 1024
    to_port = 65535
  }
  subnet_ids = [ 
    aws_subnet.private_subnet.id,
    aws_subnet.public_subnet.id
  ]
  tags = {
    Name = "my-acl"
  }
}

resource "aws_security_group" "web_sg" {
  name = "Public-SG"
  description = "Allow HTTP Web Access"
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
      Name = "Public-SG"
  }
}
resource "aws_security_group" "redmine_sg" {
  name = "Redmine-SG"
  description = "Allow Public SG access to port 5000"
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
      Name = "Redmine-SG"
  }
}
resource "aws_security_group" "database_sg" {
  name = "Database-SG"
  description = "Allow port 3306"
  vpc_id = aws_vpc.custom_vpc.id
  tags = {
      Name = "Database-SG"
  }
}

resource "aws_security_group_rule" "bastion_sg_ingress1" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_sg_egress1" {
  type = "egress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.bastion_sg.id 
  source_security_group_id = aws_security_group.redmine_sg.id
}

resource "aws_security_group_rule" "bastion_sg_egress2" {
  type = "egress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.bastion_sg.id 
  source_security_group_id = aws_security_group.database_sg.id
}

resource "aws_security_group_rule" "bastion_sg_egress3" {
  type = "egress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.bastion_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "bastion_sg_egress4" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"] 
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "bastion_sg_egress5" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "web_sg_ingress1" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "web_sg_ingress2" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "web_sg_egress1" {
  type = "egress"
  from_port = 5000
  to_port = 5000
  protocol = "tcp"
  security_group_id = aws_security_group.web_sg.id
  source_security_group_id = aws_security_group.redmine_sg.id
}

resource "aws_security_group_rule" "web_sg_egress2" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "web_sg_egress3" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "redmine_sg_ingress1" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.redmine_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "redmine_sg_ingress2" {
  type = "ingress"
  from_port = 5000
  to_port = 5000
  protocol = "tcp"
  security_group_id = aws_security_group.redmine_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "redmine_sg_egress2" {
  type = "egress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = aws_security_group.redmine_sg.id
  source_security_group_id = aws_security_group.database_sg.id
}

resource "aws_security_group_rule" "redmine_sg_egress3" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.redmine_sg.id
}

resource "aws_security_group_rule" "redmine_sg_egress4" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 security_group_id = aws_security_group.redmine_sg.id
}

resource "aws_security_group_rule" "database_sg_ingress1" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  security_group_id = aws_security_group.database_sg.id
  source_security_group_id = aws_security_group.redmine_sg.id
}

resource "aws_security_group_rule" "database_sg_ingress2" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.database_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "database_sg_egress1" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.database_sg.id
}

resource "aws_security_group_rule" "database_sg_egress2" {
  type = "egress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.database_sg.id
}

resource "aws_network_interface" "bastion_nic" {
  subnet_id = aws_subnet.public_subnet.id
  private_ips = ["10.0.2.10"]
  security_groups = [
      aws_security_group.bastion_sg.id
    ]
}

resource "aws_network_interface" "web_nic" {
  subnet_id = aws_subnet.public_subnet.id
  private_ips = ["10.0.2.20"]
  security_groups = [
      aws_security_group.web_sg.id
    ]
}

resource "aws_network_interface" "redmine_nic" {
  subnet_id = aws_subnet.private_subnet.id
  private_ips = ["10.0.1.10"]
  security_groups = [
      aws_security_group.redmine_sg.id
  ]
}

resource "aws_network_interface" "database_nic" {
  subnet_id = aws_subnet.private_subnet.id
  private_ips = ["10.0.1.20"]
  security_groups = [
      aws_security_group.database_sg.id
  ]
}

resource "aws_instance" "bastion_ec2" {
  ami = "ami-0c293f3f676ec4f90"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"
  key_name = "aws-key"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.bastion_nic.id
  }
  user_data = <<-EOF
              #!/bin/bash
              yum install python3-pip -y
              python3 -m pip install ansible ansible-core
              EOF
  tags = {
      Name = "Bastion-EC2"
  }
}

resource "aws_instance" "public_ec2" {
  ami = "ami-0e472ba40eb589f49"
  instance_type = "t2.micro"
  availability_zone = "us-east-1b"
  key_name = "aws-key"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web_nic.id
  }
  tags = {
      Name = "Public-EC2"
  }
}

resource "aws_instance" "redmine_ec2" {
  ami = "ami-0e472ba40eb589f49"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "aws-key"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.redmine_nic.id
  }
  tags = {
      Name = "Redmine-EC2"
  }
}

resource "aws_instance" "database_ec2" {
  ami = "ami-0e472ba40eb589f49"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "aws-key"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.database_nic.id
  }
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install mysql-server -y
              mysql -e "CREATE DATABASE redmine CHARACTER SET utf8;"
              mysql -e "CREATE USER 'redmine'@'%' IDENTIFIED BY 'redmine';"
              mysql -e "GRANT ALL PRIVILEGES ON redmine.* TO 'redmine'@'%';"
              sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf
              systemctl restart mysql
              EOF
  tags = {
      Name = "Database-EC2"
  }
}