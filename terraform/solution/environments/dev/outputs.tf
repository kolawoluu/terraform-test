# -----------------------------------------------------------------------------
# Root module outputs (re-export networking outputs)
# -----------------------------------------------------------------------------

output "vpc_id" {
  description = "ID of the VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs."
  value       = module.networking.public_subnet_ids
}

output "web_subnet_ids" {
  description = "List of web (private) subnet IDs."
  value       = module.networking.web_subnet_ids
}

output "database_subnet_ids" {
  description = "List of database (private) subnet IDs."
  value       = module.networking.database_subnet_ids
}

# Load Balancer Outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.loadbalancer.alb_dns_name
}

output "alb_url" {
  description = "URL to access the application (HTTP)"
  value       = "http://${module.loadbalancer.alb_dns_name}"
}

# Compute Outputs
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.compute.cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.compute.service_name
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = module.compute.log_group_name
}
