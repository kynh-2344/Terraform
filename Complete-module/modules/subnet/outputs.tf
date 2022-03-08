output "public_subnet_id" {
  value = aws_subnet.public_subnet_1a.vpc_id
}
output "subnet_az" {
    value = aws_subnet.public_subnet_1a.availability_zone
}
output "subnet_az_cidr" {
    value = aws_subnet.public_subnet_1a.cidr_block
}