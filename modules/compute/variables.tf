variable "ec2_ami" {
  description = "AMI to be used"
  type = string
}

variable "ec2_type" {
  description = "Type of the instance, e.g, t2.micro"
  type = string
}

variable "ec2_key_pair" {
  description = "Existing AWS key pair name"
  type = string
}

variable "security_group_id" {
  description = "Security Group ID for the instance"
  type = string
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type = string
}

variable "environment" {
    description = "Environment of the infrastructure"
    type = string
}

variable "instance_name" {
    description = "Name of the instance"
    type = string
}