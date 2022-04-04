resource "aws_lb" "frontend_load_balancer" {
    name                    = "${var.project}-frontend-lb-${var.environment}"
    internal                = false
    load_balancer_type      = "application"
    security_groups         = [var.alb_sg]
    subnets                 = var.public_subnets
    idle_timeout            = 60
    # Make sure that the replacement object is created first before deleting
    lifecycle {
        create_before_destroy = true 
    }
    tags = {
        Name                = "${var.project}-frontend-lb-${var.environment}"
    }
    enable_deletion_protection = true
}

resource "aws_lb_target_group" "frontend_load_balancer_target_group" {
    name                    = "${var.project}-frontend-tg-${var.environment}"
    port                    = 80
    protocol                = "HTTP"
    vpc_id                  = var.vpc_id 
    target_type             = "instance"
    health_check {
        path                = "/"
        protocol            = "HTTP"
        port                = "80" 
        healthy_threshold   = 5
        unhealthy_threshold = 3
        timeout             = 5
        interval            = 20
        matcher             = 200
    }
}

resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn       = aws_lb.frontend_load_balancer.arn
    port                    = "80"
    protocol                = "HTTP"
    default_action {
      type                  = "forward"
      target_group_arn      = aws_lb_target_group.frontend_load_balancer_target_group.arn
    }
}
