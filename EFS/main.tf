resource "aws_efs_file_system" "app_content" {
    creation_token              = "${var.project}-app-content-${var.environment}"
    encrypted                   = true
    performance_mode            = var.performance_mode
    throughput_mode             = var.throughput_mode
    tags = {
        Name                    = "${var.project}-app-content-${var.environment}"
    }
}

resource "aws_efs_mount_target" "alpha" {
    file_system_id              = aws_efs_file_system.app_content.id
    subnet_id                   = aws_subnet.alpha.id
}

resource "aws_vpc" "foo" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "alpha" {
  vpc_id            = aws_vpc.foo.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.0.1.0/24"
}