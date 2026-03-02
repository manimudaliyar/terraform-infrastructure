output "vpc_id" { # Output the VPC ID
  value = aws_vpc.main.id
}

output "subnet_id" { # Output the Subnet ID called in the compute module in main.tf
  value = aws_subnet.public.id
}

output "security_group_id" { # Output the Security Group ID called in the compute module in main.tf
  value = aws_security_group.main_SG.id
}