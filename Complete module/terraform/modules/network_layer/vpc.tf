resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true
    instance_tenancy = "default"
    tags = {
        Name = "${var.project}-vpc-${var.environment}"
    }
}

data "aws_availability_zones" "available" {}