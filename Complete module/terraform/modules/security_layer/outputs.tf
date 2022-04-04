output "app_sg" {
    value = aws_security_group.app_sg.id
}

output "alb_sg" {
    value = aws_security_group.alb_sg.id
}

output "bastion_sg" {
    value = aws_security_group.bastion_sg.id
}

output "aurora_sg" {
    value = aws_security_group.aurora_sg.id
}

output "elasticache_sg" {
    value = aws_security_group.elasticache_sg.id
}

output "efs_sg" {
    value = aws_security_group.efs_sg.id
}