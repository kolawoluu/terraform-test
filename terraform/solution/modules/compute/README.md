# Compute Module

ECS Fargate cluster and service. Expects a target group and ALB security group from the load balancer module.

## Usage

```hcl
module "compute" {
  source = "../../modules/compute"

  environment = "dev"
  service     = "nginx"
  region      = "eu-west-2"

  vpc_id                = module.networking.vpc_id
  subnet_ids            = module.networking.web_subnet_ids
  target_group_arn      = module.loadbalancer.target_group_arn
  alb_security_group_id = module.loadbalancer.alb_security_group_id

  container_name  = "app"
  container_image = "nginx:1.25.3-alpine"
  container_port  = 80

  task_cpu       = "256"
  task_memory    = "512"
  desired_count  = 2
  common_tags    = var.tags

  depends_on = [module.loadbalancer]
}
```

## Outputs

`cluster_id`, `service_id`, `security_group_id`, `task_definition_arn`, `log_group_name`.

## Requirements

Terraform >= 1.0, AWS provider >= 4.0
