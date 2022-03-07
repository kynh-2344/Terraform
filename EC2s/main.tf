provider "aws" {}

resource "aws_instance" "helloworld" {
  ami = "ami-0c293f3f676ec4f90"
  instance_type = "t2.micro"
  tags = {
    "Name" = "TerraformEC2"
  }
}