# terraform-infrastructure

![Terraform](https://img.shields.io/badge/Terraform-1.x-7B42BC?logo=terraform) ![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazonaws) ![License](https://img.shields.io/badge/License-MIT-green)

> Modular, multi-environment AWS infrastructure built with production-grade practices — remote state management, workspace isolation, and reusable modules across dev, stage, and prod.

---

## Technologies Used

Terraform · AWS (VPC, EC2, S3, DynamoDB) · Terraform Workspaces · Remote Backend (S3 + DynamoDB Locking)

---

## Overview

This project provisions a complete AWS infrastructure using Terraform with a focus on modularity and environment isolation. It demonstrates real-world patterns used in production cloud environments:

- **Environment isolation** — dev, stage, prod via Terraform workspaces
- **Remote state management** — S3 backend with DynamoDB locking and versioning
- **Reusable modules** — networking and compute separated for scalability
- **Structured tagging** — consistent naming and ownership across all resources

### Infrastructure Components

| Layer | Resources |
|---|---|
| Networking | VPC, Public Subnet, Internet Gateway, Route Table, Security Group |
| Compute | EC2 instance with key-pair access, environment-based tagging |
| Backend | S3 (state storage, versioning, encryption), DynamoDB (state locking) |

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
│   ├── networking/
│   │   ├── networks.tf
│   │   ├── variables.tf
│   │   ├── locals.tf
│   │   └── outputs.tf
│   │
│   └── compute/
│       ├── compute.tf
│       ├── variables.tf
│       └── locals.tf
│
└── terraform-backend/
    └── main.tf
```

---

## Getting Started

### Step 1 — Bootstrap the Remote Backend

The backend must be created before deploying the main infrastructure to avoid circular dependency issues.

```bash
cd terraform-backend
terraform init
terraform apply
```

This provisions the S3 bucket and DynamoDB table used for state management.

### Step 2 — Initialize Main Infrastructure

```bash
cd ..
terraform init
```

### Step 3 — Create Workspace and Deploy

```bash
terraform workspace new dev
terraform workspace select dev
terraform apply -var-file=dev.tfvars
```

Repeat for `stage` and `prod` environments.

---

## Remote State Layout

State files are isolated per workspace:

```
env:/dev/terraform-infrastructure/terraform.tfstate
env:/stage/terraform-infrastructure/terraform.tfstate
env:/prod/terraform-infrastructure/terraform.tfstate
```

---

## Naming & Tagging Convention

Resources follow environment-prefixed naming (e.g. `dev_VPC`, `prod_Main-EC2`) and include standardized tags:

| Tag | Purpose |
|---|---|
| `Environment` | Identifies dev / stage / prod |
| `Project` | Groups resources by project |
| `Owner` | Ownership for cost allocation |
| `ManagedBy` | Signals Terraform-managed resources |

---

## Security Considerations

- SSH access restricted via configurable CIDR variable
- Remote state encrypted at rest (S3 SSE)
- DynamoDB state locking prevents concurrent modifications
- `prevent_destroy` lifecycle rule protects backend S3 bucket

---

## Design Decisions

- **Backend separated from main infra** — prevents accidental state loss during destroy
- **Modular architecture** — networking and compute decoupled for independent scaling
- **Environment-specific tfvars** — clean separation of config per environment
- **Centralized tagging via locals** — single source of truth for tags across modules

---

## Future Enhancements

- [ ] Private subnets and NAT Gateway
- [ ] Application Load Balancer
- [ ] Auto Scaling Group
- [ ] IAM roles for EC2 (replacing key-based access)
- [ ] CI/CD pipeline integration
- [ ] S3 lifecycle rules for noncurrent version cleanup

---

## Author

**Manibharati Mudaliyar**  
[LinkedIn](https://linkedin.com/in/mmudaliyar) · [GitHub](https://github.com/manimudaliyar)
