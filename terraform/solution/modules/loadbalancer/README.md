# Load Balancer Module

Application Load Balancer with target group (IP type for Fargate), HTTP listener, and optional HTTPS listener. ECS registers targets via its `load_balancer` block; no target group attachments in this module.

## Usage

```hcl
module "loadbalancer" {
  source = "../../modules/loadbalancer"

  environment       = "dev"
  service           = "nginx"

  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids

  health_check_path        = "/"
  enable_deletion_protection = false
  enable_https             = false
  certificate_arn          = ""

  common_tags = var.tags
}
```

With HTTPS (set `enable_https = true` and a valid `certificate_arn`):

```hcl
module "loadbalancer" {
  source = "../../modules/loadbalancer"

  environment       = "prod"
  service           = "nginx"
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids

  enable_https    = true
  certificate_arn = aws_acm_certificate.app.arn
  common_tags     = var.tags
}
```

## Outputs

`alb_arn`, `alb_dns_name`, `target_group_arn`, `alb_security_group_id` — pass `target_group_arn` and `alb_security_group_id` to the compute module.

## Requirements

- Terraform >= 1.0, AWS provider >= 4.0
