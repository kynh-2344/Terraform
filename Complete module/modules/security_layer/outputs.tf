output "ec2_sg_id" {
    value = aws_security_group.ec2_sg.id
}

output "elb_sg_id" {
    value = aws_security_group.elb_sg.id
}