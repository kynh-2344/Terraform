# vpc 
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

# subnet
module "subnet" {
    source = "./modules/subnet"
    vpc_id = module.vpc.vpc_id
    subnet_az = var.subnet_az
    subnet_az_cidr = var.subnet_az_cidr
}