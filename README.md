# Terraform Infrastructure on AWS

## Overview

This project provisions a modular AWS infrastructure using Terraform.

It demonstrates:

- Environment isolation (dev, stage, prod)
- Remote state management using S3 and DynamoDB
- Reusable Terraform modules
- Workspace-based state separation
- Structured tagging and naming conventions

The infrastructure includes:

- VPC  
- Public Subnet  
- Internet Gateway  
- Route Table and Association  
- Security Group  
- EC2 Instance  
- Remote Backend (S3 + DynamoDB Locking)

---

## Architecture

### Networking Layer
- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group

### Compute Layer
- EC2 instance deployed into public subnet
- Uses existing AWS key pair
- Environment-based tagging strategy

### Remote Backend
- S3 bucket for Terraform state storage
- DynamoDB table for state locking
- Versioning enabled on S3 bucket
- Encryption enabled
- Lifecycle protection enabled for safety

---

## Project Structure

```
terraform-infrastructure/
│
├── backend.tf
├── main.tf
├── provider.tf
├── variables.tf
├── dev.tfvars
├── stage.tfvars
├── prod.tfvars
│
├── modules/
│ ├── networking/
│ │ ├── networks.tf
│ │ ├── variables.tf
│ │ ├── locals.tf
│ │ └── outputs.tf
│ │
│ └── compute/
│ ├── compute.tf
│ ├── variables.tf
│ └── locals.tf
│
└── terraform-backend/
└── main.tf
```

---

# Backend Bootstrapping (Must Be Executed First)

The remote backend infrastructure must be created before deploying the main infrastructure.

This avoids circular dependency issues during destroy operations.

## Step 1: Bootstrap Backend

Navigate to the backend directory:

```
cd terraform-backend
```
Initialize Terraform:
```
terraform init
```
Apply backend infrastructure:
```
terraform apply
```

This creates:

- S3 bucket for Terraform state
- DynamoDB table for state locking

---

# Deploying Main Infrastructure

## Step 2: Initialize Main Infrastructure

Return to root directory:
```
cd ..
```

Initialize Terraform (this connects to remote S3 backend):
```
terraform init
```

---

## Step 3: Create and Select Workspace

Create workspace for an environment:
```
terraform workspace new dev
terraform workspace select dev
```

---

## Step 4: Deploy Environment
```
terraform apply -var-file=dev.tfvars
```

Repeat for other environments:
```
terraform workspace new stage
terraform apply -var-file=stage.tfvars

terraform workspace new prod
terraform apply -var-file=prod.tfvars
```

---

# Remote State Layout

State files are stored per workspace:
```
env:/dev/terraform-infrastructure/terraform.tfstate
env:/stage/terraform-infrastructure/terraform.tfstate
env:/prod/terraform-infrastructure/terraform.tfstate
```

---

# Naming Convention

Resources follow environment-based naming:
```
<environment>_VPC
<environment>_IGW
<environment>_Main-EC2
```
Example:
```
dev_VPC
stage_IGW
prod_Main-EC2
```

---

# Tagging Strategy

All resources include standardized tags:

- Environment
- Project
- Owner
- ManagedBy

This ensures consistency across environments and improves maintainability.

---

# Destroying Infrastructure

To destroy a specific environment:
```
terraform workspace select dev
terraform destroy -var-file=dev.tfvars
```

Note:

The backend S3 bucket is protected using `prevent_destroy` and will not be deleted automatically.

---

# Security Considerations

- SSH access controlled via configurable CIDR variable
- Remote state locking via DynamoDB
- Backend encryption enabled
- Modular separation of networking and compute

---

# Design Decisions

- Backend separated from main infrastructure to prevent accidental state deletion
- Modular architecture for scalability and reusability
- Environment-specific tfvars for isolation
- Workspace-based state separation
- Centralized tagging strategy using locals

---

# Future Enhancements

- Private subnets and NAT Gateway
- Application Load Balancer
- Auto Scaling Group
- IAM roles for EC2 instead of key-based access
- CI/CD pipeline integration
- S3 lifecycle rules for noncurrent version cleanup

---

# Technologies Used

- Terraform
- AWS (VPC, EC2, S3, DynamoDB)
- Terraform Workspaces

---

# Author

Manibharati Mudaliyar