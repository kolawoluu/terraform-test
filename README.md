TERRAFORM_TEST/
├── .gitignore
├── README.md
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
│           └── dev/
│               ├── main.tf
│               ├── variables.tf
│               ├── outputs.tf
│               ├── versions.tf
│               └── terraform.tfvars.json