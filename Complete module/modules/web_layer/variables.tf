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

variable "alb_name" {
    type = string
    description = "Application Load Balancer custom name"
}

variable "vpc_id" {
    type = string
    description = "VPC ID"
}



