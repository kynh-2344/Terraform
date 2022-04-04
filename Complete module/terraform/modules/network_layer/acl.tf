resource "aws_network_acl" "my_public_acl" {
    vpc_id              = aws_vpc.my_vpc.id
    subnet_ids          = aws_subnet.public_subnet.*.id
    ingress {
        protocol        = "tcp"
        rule_no         = 100
        action          = "allow"
        cidr_block      = "0.0.0.0/0"
        from_port       = 80
        to_port         = 80
    }
    ingress {
        protocol        = "tcp"
        rule_no         = 110
        action          = "allow"
        cidr_block      = "0.0.0.0/0"
        from_port       = 443
        to_port         = 443
    }
    ingress {
        protocol        = "tcp"
        rule_no         = 120
        action          = "allow"
        cidr_block      = "0.0.0.0/0"
        from_port       = 22
        to_port         = 22
    }
    ingress {
        protocol        = "tcp"
        rule_no         = 130
        action          = "allow"
        cidr_block      = "0.0.0.0/0"
        from_port       = 1024
        to_port         = 65535
    }
    egress {
        protocol        = "tcp"
        rule_no         = 100
        action          = "allow"
        cidr_block      = "0.0.0.0/0"
        from_port       = 80
        to_port         = 80
    }
    egress {
        protocol        = "tcp"
        rule_no         = 110
        action          = "allow"
        cidr_block      = "0.0.0.0/0"
        from_port       = 443
        to_port         = 443
    }
    egress {
        protocol        = "tcp"
        rule_no         = 120
        action          = "allow"
        cidr_block      = "0.0.0.0/0"
        from_port       = 22
        to_port         = 22
    }
    egress {
        protocol        = "tcp"
        rule_no         = 130
        action          = "allow"
        cidr_block      = "0.0.0.0/0"
        from_port       = 1024
        to_port         = 65535
    }
    tags = {
        Name            = "${var.project}-acl-public-${var.environment}"
    }
}

resource "aws_network_acl" "my_private_acl" {
    vpc_id              = aws_vpc.my_vpc.id
    subnet_ids          = aws_subnet.private_subnet.*.id
    ingress {
        protocol        = "tcp"
        rule_no         = 100
        action          = "allow"
        cidr_block      = var.vpc_cidr_block
        from_port       = 80
        to_port         = 80
    }
    ingress {
        protocol        = "tcp"
        rule_no         = 110
        action          = "allow"
        cidr_block      = var.vpc_cidr_block
        from_port       = 443
        to_port         = 443
    }
    ingress {
        protocol        = "tcp"
        rule_no         = 120
        action          = "allow"
        cidr_block      = var.vpc_cidr_block
        from_port       = 22
        to_port         = 22
    }
    ingress {
        protocol        = "tcp"
        rule_no         = 130
        action          = "allow"
        cidr_block      = var.vpc_cidr_block
        from_port       = 3306
        to_port         = 3306
    }
    ingress {
        protocol        = "tcp"
        rule_no         = 140
        action          = "allow"
        cidr_block      = var.vpc_cidr_block
        from_port       = 6379
        to_port         = 6379
    }
    ingress {
        protocol        = "tcp"
        rule_no         = 150
        action          = "allow"
        cidr_block      = var.vpc_cidr_block
        from_port       = 2049
        to_port         = 2049
    }

    ingress {
        protocol        = "tcp"
        rule_no         = 160
        action          = "allow"
        cidr_block      = "0.0.0.0/0"
        from_port       = 22
        to_port         = 22
    }

    ingress {
        protocol        = "tcp"
        rule_no         = 170
        action          = "allow"
        cidr_block      = "0.0.0.0/0"
        from_port       = 1024
        to_port         = 65535
    }
    egress {
        protocol        = "all"
        rule_no         = 100
        action          = "allow"
        cidr_block      = "0.0.0.0/0"
        from_port       = 0
        to_port         = 0
    }
    tags = {
        Name            = "${var.project}-acl-private-${var.environment}"
    }
}