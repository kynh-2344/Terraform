variable "project" {
    type        = string
    description = "Name of project"
}

variable "environment" {
    type        = string
    description = "Name of environment"
}

# NETWORK

variable "vpc_cidr_block" {
    type        = string
    description = "CIDR Block of VPC"
}

variable "public_ip" {
    type        = string
    description = "Local Public IP"
}

variable "public_subnet_number" {
    type        = string
    description = "Name of public subnets"
}

variable "public_cidr_blocks" {
    type        = list
    description = "A list of public subnet CIDR Block"
}

variable "private_subnet_number" {
    type        = string
    description = "Name of private subnets"
}

variable "private_cidr_blocks" {
    type        = list
    description = "A list of private subnet CIDR Block"
}

# EC2s

variable "instance_number" {
    type        = number 
    description = "A numbber of instances"
}

variable "instance_type" {
    type        = string
    description = "Instance type"
}

variable "instance_class" {
    type        = string
    description = "Instance class"
}

# RDS

variable "database_engine" {
    type        = string
    description = "Aurora engine"
}

variable "database_version" {
    type        = string
    description = "Aurora version"
}

variable "node_class" {
    type        = string
    description = "ElastiCache Class"
}

variable "cache_engine" {
    type        = string
    description = "ElastiCache Engine"
}

variable "cache_version" {
    type        = string
    description = "ElastiCache Engine Version"
}

variable "cache_family" {
    type        = string
    description = "ElastiCache Family"
}

variable "elasticache_parameter_group" {
    type        = list
    description = "ElastiCache Parameter Group"
}

variable "aurora_parameter_group" {
    type        = list
    description = "Aurora Parameter Group"
}

variable "replicas_per_node_group" {
    type        = number
    description = "Replicas Per Elasticache Node"
}


variable "aurora_user" {
    type        = string 
    description = "Aurora username"
}

variable "aurora_database_name" {
    type        = string
    description = "Aurora database name"
}

variable "backup_retention_period" {
    type        = number
    description = "Backup rentation perioud"
}

variable "app_port" {
    type        = number
    description = "APP port"
}

variable "bastion_instance_number" {
    type        = number
    description = "A number of bastion instances" 
}   

variable "min_scale_size" {
    type        = number
    description = "Min EC2 numbers"
}

variable "max_scale_size" {
    type        = number
    description = "Max EC2 numbers"
}

variable "app_cpu_target" {
    type        = number
    description = "App Average CPU Utilization target"
}

variable "instance_volume_size" {
    type        = number
    description = "Instance Volume Size"
}

variable "instance_volume_type" {
    type        = string
    description = "Instance Volume Type"
}

variable "instance_keypair_name" {
    type        = string
    description = "SSH key name"
}

variable "eip_number" {
    type        = number
    description = "Number of Elastic IP"
}

variable "region" {
    type        = string
    description = "AWS Region"
}

variable "bucket_list" {
    type        = list
    description = "A list of S3 buckets"
}

variable "efs_performance_mode" {
    type = string
    description = "EFS Performance Mode"
}

variable "efs_throughput_mode" {
    type = string
    description = "EFS Throughput Mode"   
}