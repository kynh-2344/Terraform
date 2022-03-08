# Terraform

## aws-cli command example

```bash
aws ec2 describe-images --region us-east-1  --owners amazon --filters "Name=name,Values=amzn2-ami-hvm*" "Name=root-device-type,Values=ebs" "Name=architecture,Values=x86_64"
```
