locals {
  common_tags = {
    Environment = var.environment
    Project = "terraform-infrastructure"
    Owner = "Manibharati M"
    ManagedBy = "Terraform"
  }
}