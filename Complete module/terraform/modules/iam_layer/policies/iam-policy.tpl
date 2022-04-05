{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:List*",
                "s3:Get*",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource" : ${jsonencode(split(",",top_bucket_arns))}
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:List*",
                "s3:Get*",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource" : ${jsonencode(split(",",sub_bucket_arns))}
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "cloudwatch:PutMetricData",
                "ec2:DescribeVolumes",
                "ec2:DescribeTags",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource" : "*"
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "ssm:GetParameter"
            ],
            "Resource" : "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
        }
    ]
}