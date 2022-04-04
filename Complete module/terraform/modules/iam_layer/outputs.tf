output "ec2_iam_role" {
    value = aws_iam_instance_profile.instance_profile.name
}
