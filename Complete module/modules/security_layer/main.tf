resource "aws_security_group" "elb_sg" {
    name = "lab-architect-sg-elb"
    vpc_id = var.vpc_id
    description = "Allow HTTP Web Access"
    ingress {
        protocol = "tcp"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "lab-architect-sg-elb"
    }
}

resource "aws_security_group" "ec2_sg" {
    name = "lab-architect-sg-ec2"
    vpc_id = var.vpc_id
    description = "Allow SSH"
    tags = {
        Name = "lab-architect-sg-ec2"
    }
}

resource "aws_security_group_rule" "ec2_sg_http_inbound" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = aws_security_group.ec2_sg.id
    source_security_group_id = aws_security_group.elb_sg.id
}

resource "aws_security_group_rule" "ec2_sg_ssh_inbound" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = aws_security_group.ec2_sg.id
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2_sg_ssh_outbound1" {
    type = "egress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_group_id = aws_security_group.ec2_sg.id
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2_sg_ssh_outbound2" {
    type = "egress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = aws_security_group.ec2_sg.id
    cidr_blocks = ["0.0.0.0/0"]
}

