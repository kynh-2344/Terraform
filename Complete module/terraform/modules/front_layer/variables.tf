# PROJECT LAYER
variable "project" {}
variable "environment" {}

# NETWORK LAYER
variable "vpc_id" {}
variable "vpc_cidr_block" {}
variable "private_subnets" {}
variable "public_subnets" {}
variable "ec2_iam_role" {}
# INSTANCE LAYER
variable "instance_type" {}
variable "instance_volume_size" {}
variable "instance_volume_type" {}
variable "instance_keypair_name" {}
variable "bastion_instance_number" {}
variable "bastion_sg" {}
variable "alb_sg" {}


