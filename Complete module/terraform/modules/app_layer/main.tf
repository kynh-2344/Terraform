resource "aws_launch_configuration" "app_launch_config" {
    name                        = "${var.project}-app-launch-${var.environment}"
    image_id                    = data.aws_ami.app_instance_data.id
    instance_type               = var.instance_type
    key_name                    = var.instance_keypair_name
    root_block_device {
        volume_type             = var.instance_volume_type
        volume_size             = var.instance_volume_size
        delete_on_termination   = true
        encrypted               = false
        iops                    = 3000
    }
    security_groups             = [var.app_sg]
    iam_instance_profile        = var.ec2_iam_role
}

resource "aws_autoscaling_group" "autoscale_app" {
    name                        = "${var.project}-auto-scale-app-group-${var.environment}"
    vpc_zone_identifier         = var.private_subnets
    launch_configuration        = aws_launch_configuration.app_launch_config.name 
    min_size                    = var.min_scale_size
    max_size                    = var.max_scale_size
    desired_capacity            = var.min_scale_size
    termination_policies        = ["NewestInstance"]
    health_check_type           = "ELB"
    health_check_grace_period   = 300
    tag {
        key                     = "Name"
        value                   = "${var.project}-auto-scale-app-group-${var.environment}"
        propagate_at_launch     = true
    }
    tag {
        key                     = "ServerType"
        value                   = "Backend"
        propagate_at_launch     = true
    }
    tag {
        key                     = "Environment"
        value                   = var.environment
        propagate_at_launch     = true
    }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
    autoscaling_group_name      = aws_autoscaling_group.autoscale_app.id
    lb_target_group_arn         = var.frontend_lb_target_arn
}

resource "aws_autoscaling_policy" "scale_policty" {
    name                        = "Target Tracking Policty"
    autoscaling_group_name      = aws_autoscaling_group.autoscale_app.name
    policy_type                 = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization" 
        } 
        target_value            = var.app_cpu_target
    }
}