resource "aws_iam_role" "iam_role_ec2" {
    name                    = "${var.env}-iam-role"
    assume_role_policy      = file("${path.module}/policies/role-policy.json")
    description             = "${var.env}-test"
}

resource "aws_iam_role_policy" "iam_role_policy_ec2" {
    name                    = "${var.env}-iam-role-policy"
    role                    = aws_iam_role.iam_role_ec2.id
    policy                  = data.template_file.policy_template.rendered
}

resource "aws_iam_instance_profile" "iam_profile" {
    name                    = "${var.env}-profile"
    role                    = aws_iam_role.iam_role_ec2.name
}

data "template_file" "policy_template" {
    template                = file("./policies/iam-policy.json")
    vars = {
        bucket_arn          = "${aws_s3_bucket.s3_bucket.arn}"
    }
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket                  = "terraform-my-bucket-lab"
    force_destroy           = true
    tags = {
      Name                  = "Bucket"
    }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket                    = aws_s3_bucket.s3_bucket.id
  acl                       = "private"
}

resource "aws_s3_object" "log_folder" {
  bucket                    = "${aws_s3_bucket.s3_bucket.bucket}"
  key                       = "http-log/"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                   = data.aws_ami.ubuntu.id
  instance_type         = "t2.micro"
  iam_instance_profile  = aws_iam_instance_profile.iam_profile.name
  tags = {
    Name = "HelloWorld"
  }
}