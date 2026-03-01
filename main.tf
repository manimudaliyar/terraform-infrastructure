module "networking" {
  source = "./modules/networking"
  vpc_cidr = var.vpc_cidr
  subnet_index = var.subnet_index
}

module "compute" {
  source = "./modules/compute"
  subnet_id = module.networking.subnet_id
  security_group_id = module.networking.security_group_id
  ec2_ami = var.ec2_ami
  ec2_key_pair = var.ec2_key_pair
  ec2_type = var.ec2_type
  environment = var.environment
  instance_name = var.instance_name
}