resource "aws_subnet" "public_subnet" {
    vpc_id                      = aws_vpc.my_vpc.id
    count                       = var.public_subnet_number
    cidr_block                  = var.public_cidr_blocks[count.index]
    map_public_ip_on_launch     = true
    availability_zone           = data.aws_availability_zones.filtered_zones.names[count.index]
    tags = {
        Name                    = "${var.project}-subnet-public-${count.index+1}-${var.environment}"
    }
}

resource "aws_route_table" "public_route" {
    vpc_id                      = aws_vpc.my_vpc.id
    route {
        cidr_block              = "0.0.0.0/0"
        gateway_id              = aws_internet_gateway.my_igw.id
    }
    tags = {
        Name                    = "${var.project}-public-route-${var.environment}"
    }
}

resource "aws_route_table_association" "associate_public_subnet" {
    count                       = var.public_subnet_number
    subnet_id                   = aws_subnet.public_subnet.*.id[count.index]
    route_table_id              = aws_route_table.public_route.id
}