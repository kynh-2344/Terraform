output "vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "igw_id" {
    value = aws_internet_gateway.my_igw.id
}

output "public_subnet_1a" {
    value = aws_subnet.public_subnet_1a.id
}

output "public_subnet_1b" {
    value = aws_subnet.public_subnet_1b.id
}