variable "igw_id" {
    type = string
    description = "network-layer internet gateway ID"
}

variable "subnet_id" {
    type = list
    description = "Public-Subnet ID"
}

variable "vpc_id" {
    type = string
    description = "VPC ID"
}