# ---------------------------------------
# Compute Module
# Creates:
# - EC2 Instance
#
# Expects:
# - subnet_id
# - security_group_id
# - ec2_ami
# - ec2_type
# - ec2_key_pair
# - environment
#
# Applies:
# - Standardized tagging via local.common_tags
# ---------------------------------------
resource "aws_instance" "main_EC2" { # Create an EC2 instance
  ami = var.ec2_ami
  instance_type = var.ec2_type
  key_name = var.ec2_key_pair
  vpc_security_group_ids = [ var.security_group_id ] # Use the Security Group ID from the networking module which is passed as a variable
  subnet_id = var.subnet_id # Use the Subnet ID from the networking module which is passed as a variable
  tags = local.common_tags
}