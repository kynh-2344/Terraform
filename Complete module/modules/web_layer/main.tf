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
    key_name        = "aws-key"
    security_groups = [var.ec2_sg_id]
    subnet_id       = var.subnet_id[0]
    user_data = <<-EOF
                #!/bin/sh
                yum -y install httpd php telnet
                chkconfig httpd on
                cd /var/www/html
                wget https://us-west-2-aws-training.s3.amazonaws.com/awsu-spl/spl03-working-elb/static/examplefiles-elb.zip
                unzip examplefiles-elb.zip
                /usr/sbin/httpd -DFOREGROUND
                EOF
    tags = {
        Name = var.instance_name[0]
    }
}

resource "aws_instance" "lab_architect_ec2_2" {
    ami             = data.aws_ami.public_instance_data.id
    instance_type   = "t2.micro"
    key_name        = "aws-key"
    security_groups = [var.ec2_sg_id]
    subnet_id       = var.subnet_id[1]
    user_data = <<-EOF
                #!/bin/sh
                yum -y install httpd php telnet
                chkconfig httpd on
                cd /var/www/html
                wget https://us-west-2-aws-training.s3.amazonaws.com/awsu-spl/spl03-working-elb/static/examplefiles-elb.zip
                unzip examplefiles-elb.zip
                /usr/sbin/httpd -DFOREGROUND
                EOF
    tags = {
        Name = var.instance_name[1]
    }
}

resource "aws_alb" "lab_architect_alb_front" {
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
    enable_deletion_protection = true
}

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

resource "aws_lb_target_group_attachment" "attach_target" {
    target_group_arn    = aws_lb_target_group.lab_architect_alb_tgp_front.arn
    count       = length([
        aws_instance.lab_architect_ec2_1.id,
        aws_instance.lab_architect_ec2_2.id
    ])
    target_id           = element([aws_instance.lab_architect_ec2_1.id,aws_instance.lab_architect_ec2_2.id], count.index )
    port                = 80
}