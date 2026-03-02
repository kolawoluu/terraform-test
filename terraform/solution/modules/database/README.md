# Database Module

RDS instance (Postgres or MySQL) in private subnets with security group, DB subnet group, and Secrets Manager secret for credentials.

## Usage

```hcl
module "database" {
  source = "../../modules/database"

  environment = "dev"
  service     = "database"

  vpc_id                     = module.networking.vpc_id
  subnet_ids                 = module.networking.database_subnet_ids
  allowed_security_group_ids = [module.networking.web_security_group_id]

  db_name             = "appdb"
  db_master_username  = "dbadmin"
  db_engine           = "postgres"
  db_engine_version   = "13.7"
  db_instance_class   = "db.t3.micro"
  db_allocated_storage = 20
  db_multi_az         = false
  common_tags         = var.tags
}
```

## Outputs

`db_endpoint`, `db_address`, `db_port`, `security_group_id`, `secret_arn`, `secret_name`.

## Requirements

Terraform >= 1.0, AWS provider >= 4.0, random provider
