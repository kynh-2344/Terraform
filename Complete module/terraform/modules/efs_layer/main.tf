resource "aws_efs_file_system" "efs_content" {
    creation_token              = "${var.project}-efs-content-${var.environment}"
    encrypted                   = true
    performance_mode            = var.efs_performance_mode
    throughput_mode             = var.efs_throughput_mode
    tags = {
        Name                    = "${var.project}-efs-content-${var.environment}"
    }
}

resource "aws_efs_mount_target" "path" {
    count                       = length(var.private_subnets)
    file_system_id              = aws_efs_file_system.efs_content.id
    subnet_id                   = var.private_subnets[count.index]
    security_groups             = [var.efs_sg]
}