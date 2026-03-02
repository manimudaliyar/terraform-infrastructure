module "networking" {
  source = "./modules/networking"
  vpc_cidr = var.vpc_cidr # Pass the VPC CIDR block variable to the networking module
  subnet_index = var.subnet_index # Pass the subnet index variable to the networking module for cidrsubnet() function
}

module "compute" {
  source = "./modules/compute"
  subnet_id = module.networking.subnet_id # Pass the Subnet ID output from the networking module outputs to the compute module
  security_group_id = module.networking.security_group_id # Pass the Security Group ID output from the networking module outputs to the compute module
  ec2_ami = var.ec2_ami
  ec2_key_pair = var.ec2_key_pair
  ec2_type = var.ec2_type
  environment = var.environment
  instance_name = var.instance_name
}