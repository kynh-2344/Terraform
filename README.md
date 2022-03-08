# Terraform

## aws-cli command example

```bash
aws ec2 describe-images --region us-east-1  --owners amazon --filters "Name=name,Values=amzn2-ami-hvm*" "Name=root-device-type,Values=ebs" "Name=architecture,Values=x86_64"
```
## Apply a specific tartget 

```bash
terraform apply -target RESOURCE_TYPE.RESOURCE_NAME --auto-approve
```

## Destroy a specific tartget 

```bash
terraform destroy -target RESOURCE_TYPE.RESOURCE_NAME --auto-approve
```

## Show All state 

```bash
terraform state list
```

## Show a specific state

```bash
terraform state show RESOURCE_TYPE.RESOURCE_NAME
```
