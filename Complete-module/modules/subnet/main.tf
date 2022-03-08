resource "aws_subnet" "public_subnet_1a" {
  vpc_id = var.vpc_id
  availability_zone = var.subnet_az
  cidr_block = var.subnet_az_cidr
  map_public_ip_on_launch = true
}