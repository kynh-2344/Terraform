output "efs_mount_target_dns_name" {
    value = aws_efs_mount_target.alpha.mount_target_dns_name
}

output "efs_dns_name" {
    value = aws_efs_file_system.app_content.dns_name
}