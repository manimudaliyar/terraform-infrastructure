variable "vpc_cidr" {
    description = "VPC CIDR block"
    type = string
}

variable "availability_zone" {
    description = "Availability Zone for the subnet, etc"
    default = "ap-south-1a"
    type = string
}

variable "environment" {
    description = "Environment of the infrastructure"
    default = "dev"
    type = string
}

variable "subnet_index" {
    description = "Netnum number for cidrsubnet()"
    type = number
}

variable "allowed_ssh_cidr" {
  description = "CIDR block to be allowed to SSH to the instance"
  default = "0.0.0.0/0"
  type = string
}