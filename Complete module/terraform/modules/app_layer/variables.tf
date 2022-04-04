# PROJECT LAYER
variable "project" {}
variable "environment" {}

# NETWORK LAYER
variable "vpc_id" {}
variable "vpc_cidr_block" {}
variable "min_scale_size" {}
variable "private_subnets" {}

# INSTANCE LAYER
variable "frontend_lb_target_arn" {}
variable "app_port" {}
variable "max_scale_size" {}
variable "instance_type" {}
variable "app_cpu_target" {}
variable "instance_volume_size" {}
variable "instance_volume_type" {}
variable "instance_keypair_name" {}
variable "aurora_user" {} 
variable "aurora_database_name" {}
variable "aurora_password" {}
variable "aurora_endpoint" {}
variable "ec2_iam_role" {}
variable "app_sg" {}
data "aws_ami" "app_instance_data"{
    most_recent = true
    owners      = ["self"]
    filter {
        name    = "name"
        values  = ["app-ami-*"]
    }
    filter {
        name    = "architecture"
        values  = ["x86_64"]
    }
    filter {
        name    = "virtualization-type"
        values  = ["hvm"]
    }
    filter {
        name    = "hypervisor"
        values  = ["xen"]
    }
    filter {
        name    = "image-type"
        values  = ["machine"]
    }
}

