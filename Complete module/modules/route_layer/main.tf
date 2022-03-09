resource "aws_route_table" "public_route" {
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.igw_id
    }
    tags = {
        Name = "Public-Route"
    }
}

resource "aws_route_table_association" "subnet_association" {
    count = length(var.subnet_id)
    route_table_id = aws_route_table.public_route.id
    subnet_id = element(var.subnet_id, count.index)
}
