output "load_balance_dns" {
    value = aws_lb.frontend_load_balancer.dns_name
}

output "frontend_lb_target_arn" {
    value = aws_lb_target_group.frontend_load_balancer_target_group.arn
}