terraform {
  backend "s3" {
    bucket = "terraform-infra-state-file-bucket-mani"
    key = "terraform-infrastructure/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
  }
}