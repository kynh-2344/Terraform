instance_names  = [
    "lab-architect-ec2_1",
    "lab-architect-ec2_2"
]
instance_type   = "t2.micro"
alb_name        = "lab-architect-alb-front"

min_scale_size  = 2
max_scale_size  = 4

project         = "devops"
environment     = "dev"
vpc_cidr_block  = "10.0.0.0/16"