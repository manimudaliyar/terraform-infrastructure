resource "aws_instance" "main_EC2" {
  ami = var.ec2_ami
  instance_type = var.ec2_type
  key_name = var.ec2_key_pair
  vpc_security_group_ids = [ var.security_group_id ]
  subnet_id = var.subnet_id
  tags = local.common_tags
}