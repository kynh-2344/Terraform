variable "ec2_sg_id" {
    type = string
    description = "EC2 SG ID"
}

variable "subnet_id" {
    type = list
    description = "Subnet ID"
}

variable "elb_sg_id" {
    type = string
    description = "EC2 SG ID"
}

variable "instance_name" {
    type = list
    description = "EC2 names"
}

variable "instance_type" {
    type = string
    description = "Instance Type"
}

variable "alb_name" {
    type = string
    description = "Application Load Balancer custom name"
}

variable "vpc_id" {
    type = string
    description = "VPC ID"
}

variable "min_scale_size" {
    type = number
    description = "Min EC2 numbers"
}

variable "max_scale_size" {
    type = number
    description = "Max EC2 numbers"
}

