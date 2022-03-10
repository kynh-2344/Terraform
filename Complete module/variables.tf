variable "instance_names" {
    type = list
    description = "Instance names"
}

variable "instance_type" {
    type = string
    description = "Instance type"
}

variable "alb_name" {
    type = string
    description = "Instance names"
}

variable "min_scale_size" {
    type = number
    description = "Min EC2 numbers"
}

variable "max_scale_size" {
    type = number
    description = "Max EC2 numbers"
}

variable "project" {
    type = string
    description = "Project name"
}

variable "environment" {
    type = string
    description = "Environment name"
}

variable "vpc_cidr_block" {
    type = string
    description = "VPC CIDR Block"
}