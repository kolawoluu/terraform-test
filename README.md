This repository is a Terraform demonstration project.  The `original` directory contains the broken starting
code from the exercise, while `solution` holds a fully working refactor using modules for networking, compute,
load‑balancer and database.

Each environment (dev/prod) has its own small root configuration that calls the reusable modules.  Provider and
backend examples live alongside them as commented templates (`providers.tf`, `backend.tf`), so you can copy them
into place when ready to switch to real AWS credentials or a remote state bucket.

TERRAFORM_TEST/
├── .gitignore
├── README.md                      # this file
├── ASSUMPTIONS.md
├── IMPROVEMENTS.md
├── diagrams/
│   └── architecture.png
├── terraform/
│   ├── original/              # Original broken code (for reference)
│   │   ├── lb.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   │
│   └── solution/              # Fixed and improved
│       ├── modules/
│       │   ├── networking/
│       │   │   ├── vpc.tf
│       │   │   ├── subnets.tf
│       │   │   ├── internet_gateway.tf
│       │   │   ├── nat_gateway.tf
│       │   │   ├── route_tables.tf
│       │   │   ├── locals.tf
│       │   │   ├── variables.tf
│       │   │   ├── outputs.tf
│       │   │   ├── versions.tf
│       │   │   └── README.md
│       │   ├── compute/
│       │   │   ├── ecs.tf
│       │   │   ├── iam.tf
│       │   │   ├── security_groups.tf
│       │   │   ├── cloudwatch.tf
│       │   │   ├── variables.tf
│       │   │   ├── outputs.tf
│       │   │   ├── versions.tf
│       │   │   └── README.md
│       │   ├── database/
│       │   │   ├── database.tf
│       │   │   ├── sg.tf
│       │   │   ├── secrets.tf
│       │   │   ├── random.tf
│       │   │   ├── variables.tf
│       │   │   ├── outputs.tf
│       │   │   ├── versions.tf
│       │   │   └── README.md
│       │   └── loadbalancer/
│       │       ├── loadbalancer.tf
│       │       ├── variables.tf
│       │       ├── outputs.tf
│       │       ├── versions.tf
│       │       └── README.md
│       │
│       └── environments/
│           ├── dev/
│           │   ├── main.tf
│           │   ├── variables.tf
│           │   ├── outputs.tf
│           │   ├── versions.tf
│           │   └── terraform.tfvars.json
│           └── prod/              # same structure as dev, real deployments should use it too
