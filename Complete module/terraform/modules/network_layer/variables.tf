# PROJECT LAYER
variable "project" {}
variable "environment" {}
variable "region" {}

# NETWORK LAYER
variable "vpc_cidr_block" {}
variable "public_subnet_number" {}
variable "public_cidr_blocks" {}
variable "private_subnet_number" {}
variable "eip_number" {}
variable "private_cidr_blocks" {}
variable "public_ip" {}
data "aws_availability_zones" "filtered_zones" {
    state           = "available"
    exclude_names   = ["${var.region}-atl-1a"]
}