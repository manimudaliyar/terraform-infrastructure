variable "region" {
  description = "Region for the Infra"
  type = string
}

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

variable "environment" {
    description = "Environment of the infrastructure"
    default = "dev"
    type = string
}

variable "vpc_cidr" {
    description = "VPC CIDR block"
    type = string
}

variable "subnet_index" {
    description = "Netnum number for cidrsubnet()"
    type = number
}

variable "instance_name" {
    description = "Name of the instance"
    type = string
}