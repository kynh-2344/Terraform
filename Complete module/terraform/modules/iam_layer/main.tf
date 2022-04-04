data "template_file" "role_policy_template" {
    template            = file("${path.module}/policies/iam-policy.tpl")
    vars = {
        top_bucket_arns = "${join(",",var.bucket_arns)}"
        sub_bucket_arns = "${join("/*,",var.bucket_arns)}/*"
    }
}

data "template_file" "iam_policy_template" {
    template            = file("${path.module}/policies/role-policy.tpl")
    vars = {
        user_arn        = data.aws_caller_identity.current.arn
    }
}

resource "aws_iam_role" "ec2_iam_role" {
    name                = "${var.project}-ec2-ami-role-${var.environment}"
    assume_role_policy  = data.template_file.iam_policy_template.rendered
    description         = "${var.project}-ec2-ami-role-${var.environment}"
}

resource "aws_iam_role_policy" "ec2_iam_policy_role" {
    name                = "${var.project}-iam-role-policy-${var.environment}"
    role                = aws_iam_role.ec2_iam_role.id
    policy              = data.template_file.role_policy_template.rendered
}

resource "aws_iam_instance_profile" "instance_profile" {
    name                = "${var.project}-instance-profile-${var.environment}"
    role                = aws_iam_role.ec2_iam_role.name
}
