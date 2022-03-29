variable "project" {
    type = string
    description = "Project name"
}

variable "environment" {
    type = string
    description = "Environment name"
}

variable "performance_mode" {
    type = string
    description = "EFS Performance Mode"
}

variable "throughput_mode" {
    type = string
    description = "EFS Throughput Mode"
}