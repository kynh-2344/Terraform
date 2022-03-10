data "aws_ami" "public_instance_data"{
    most_recent = true
    owners = ["amazon"]
    filter {
        name    = "name"
        values  = ["amzn2-ami-kernel-*-ebs"]
    }
    filter {
        name    = "architecture"
        values  = ["x86_64"]
    }
    filter {
        name    = "virtualization-type"
        values  = ["hvm"]
    }
    filter {
        name    = "hypervisor"
        values  = ["xen"]
    }
    filter {
        name    = "image-type"
        values  = ["machine"]
    }
}

resource "aws_instance" "lab_architect_ec2_1" {
    ami             = data.aws_ami.public_instance_data.id
    instance_type   = "t2.micro"
    #key_name        = "aws-key"
    security_groups = [var.ec2_sg_id]
    subnet_id       = var.subnet_id[0]
    user_data = <<-EOF
                #!/bin/sh
                yum -y install httpd php telnet
                chkconfig httpd on
                cd /var/www/html
                wget https://us-west-2-aws-training.s3.amazonaws.com/awsu-spl/spl03-working-elb/static/examplefiles-elb.zip
                unzip examplefiles-elb.zip
                #/usr/sbin/httpd -DFOREGROUND
                systemctl start httpd
                systemctl enable httpd
                EOF
    tags = {
        Name = var.instance_name[0]
    }
}

# resource "aws_instance" "lab_architect_ec2_2" {
#     ami             = data.aws_ami.public_instance_data.id
#     instance_type   = "t2.micro"
#     #key_name        = "aws-key"
#     security_groups = [var.ec2_sg_id]
#     subnet_id       = var.subnet_id[1]
#     user_data = <<-EOF
#                 #!/bin/sh
#                 yum -y install httpd php telnet
#                 chkconfig httpd on
#                 cd /var/www/html
#                 wget https://us-west-2-aws-training.s3.amazonaws.com/awsu-spl/spl03-working-elb/static/examplefiles-elb.zip
#                 unzip examplefiles-elb.zip
#                 #/usr/sbin/httpd -DFOREGROUND
#                 systemctl start httpd
#                 systemctl enable httpd
#                 EOF
#     tags = {
#         Name = var.instance_name[1]
#     }
# }

# Create extract AMI copy from above to do auto-scaling
resource "aws_ami_from_instance" "scale_ami" {
    name                    = "ami-auto-scale"
    source_instance_id      = aws_instance.lab_architect_ec2_1.id
    depends_on = [
        aws_instance.lab_architect_ec2_1
    ]
    snapshot_without_reboot = true
}

# Create ALB
resource "aws_lb" "lab_architect_alb_front" {
    name                = "lab-architect-alb-front"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [var.elb_sg_id]
    subnets             = var.subnet_id
    idle_timeout        = 60
    # Make sure that the replacement object is created first before deleting
    # lifecycle {
    #     create_before_destroy = true 
    # }
    tags = {
        Name = var.alb_name
    }
    #enable_deletion_protection = true
}

# Create Target Group
resource "aws_lb_target_group" "lab_architect_alb_tgp_front" {
    name        = "lab-architect-alb-tgp-front"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = var.vpc_id 
    target_type = "instance"
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

locals {
    instance_id = [
        aws_instance.lab_architect_ec2_1.id,
        #aws_instance.lab_architect_ec2_2.id
    ]
}

# Attach EC2 Instances to the Target Group
resource "aws_lb_target_group_attachment" "attach_target_1" {
    target_group_arn    = aws_lb_target_group.lab_architect_alb_tgp_front.arn
    count               = length(local.instance_id)
    target_id           = element(local.instance_id, count.index )
    port                = 80
}

# Attach Target Group to ALB Listener
resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn   = aws_lb.lab_architect_alb_front.arn
    port                = "80"
    protocol            = "HTTP"
    default_action {
      type              = "forward"
      target_group_arn  = aws_lb_target_group.lab_architect_alb_tgp_front.arn
    }
}

# Launch configuration for Auto-Scale 
resource "aws_launch_configuration" "launch_config" {
    name                    = "lab-architect-web-front"
    image_id                = aws_ami_from_instance.scale_ami.id
    instance_type           = var.instance_type
    #key_name               = "aws-key"
    root_block_device {
        volume_type             = "gp2"
        #device_name            = "/dev/xvda"
        volume_size             = 8
        delete_on_termination   = true
        encrypted               = false
        iops                    = 300
    }
    security_groups         = [var.ec2_sg_id]
}

# Create Auto Scale Group 
resource "aws_autoscaling_group" "lab_architect_lcf_web_front" {
    name                        = "lab-architect-lcf-web-front"
    vpc_zone_identifier         = var.subnet_id
    #target_group_arns          = [aws_lb_target_group.lab_architect_alb_tgp_front.arn]
    launch_configuration        = aws_launch_configuration.launch_config.name 
    min_size                    = var.min_scale_size
    max_size                    = var.max_scale_size
    desired_capacity            = var.min_scale_size
    termination_policies        = ["NewestInstance"]
    health_check_type           = "ELB"
    health_check_grace_period   = 300
    tag {
        key                     = "Name"
        value                   = "lab-architect-web-front"
        propagate_at_launch     = true
    }
    tag {
        key                     = "ServerType"
        value                   = "frontend"
        propagate_at_launch     = true
    }
    tag {
        key                     = "Environment"
        value                   = "dev"
        propagate_at_launch     = true
    }
}

# Create Auto-scale Group Attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
    autoscaling_group_name  = aws_autoscaling_group.lab_architect_lcf_web_front.id
    lb_target_group_arn     =  aws_lb_target_group.lab_architect_alb_tgp_front.arn
}

# Create Auto-Scale Group Policty
resource "aws_autoscaling_policy" "scale_policty" {
    name                    = "Target Tracking Policty"
    autoscaling_group_name  = aws_autoscaling_group.lab_architect_lcf_web_front.name
    policy_type             = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization" 
        } 
        target_value = 20.0
    }
}
