# -----------------------------------------------------------------------------
# Root module: compose networking and other components
# -----------------------------------------------------------------------------

module "networking" {
  source = "../../modules/networking"

  environment_name = var.environment
  region           = var.region
  tags             = var.tags

  vpc_cidr_block     = var.vpc_cidr_block
  availability_zones = var.availability_zones

  public_subnet_cidr_blocks   = var.public_subnet_cidr_blocks
  web_subnet_cidr_blocks      = var.web_subnet_cidr_blocks
  database_subnet_cidr_blocks = var.database_subnet_cidr_blocks
}


# Load Balancer Module
module "loadbalancer" {
  source = "../../modules/loadbalancer"

  environment       = var.environment
  service           = "nginx"
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  health_check_path = var.health_check_path

  enable_deletion_protection = var.enable_alb_deletion_protection
  enable_access_logs         = var.enable_alb_access_logs

  common_tags = var.tags
}

# Compute Module (ECS)
module "compute" {
  source                = "../../modules/compute"
  region                = var.region
  environment           = var.environment
  service               = "nginx"
  vpc_id                = module.networking.vpc_id
  subnet_ids            = module.networking.web_subnet_ids
  target_group_arn      = module.loadbalancer.target_group_arn
  alb_security_group_id = module.loadbalancer.alb_security_group_id

  container_name        = var.container_name
  container_image       = var.container_image
  container_port        = var.container_port
  container_environment = var.container_environment

  task_cpu    = var.task_cpu
  task_memory = var.task_memory





  log_retention_days = var.log_retention_days

  enable_autoscaling       = var.enable_autoscaling
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity

  common_tags = var.tags

  depends_on = [module.loadbalancer]
}


# Database Module (RDS)
module "database" {
  source = "../../modules/database"

  environment                = var.environment
  service                    = "database"
  vpc_id                     = module.networking.vpc_id
  database_subnet_ids        = module.networking.database_subnet_ids
  allowed_security_group_ids = [module.compute.security_group_id]

  db_name            = var.db_name
  db_master_username = var.db_master_username
  db_engine          = var.db_engine
  db_engine_version  = var.db_engine_version
  db_instance_class  = var.db_instance_class

  db_allocated_storage = var.db_allocated_storage
  db_storage_type      = var.db_storage_type

  db_multi_az                = var.db_multi_az
  db_backup_retention_period = var.db_backup_retention_period
  db_deletion_protection     = var.db_deletion_protection

  common_tags = var.tags
}
