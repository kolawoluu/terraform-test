# -----------------------------------------------------------------------------
# Root module variables
# -----------------------------------------------------------------------------

variable "environment" {
  description = "Environment or project name (e.g. dev, prod). Used as name_prefix for resources."
  type        = string
}

variable "region" {
  description = "Region for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "List of availability zone names for subnets."
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for public subnets (one per AZ)."
  type        = list(string)
}

variable "web_subnet_cidr_blocks" {
  description = "CIDR blocks for web (private) subnets (one per AZ)."
  type        = list(string)
}

variable "database_subnet_cidr_blocks" {
  description = "CIDR blocks for database (private) subnets (one per AZ)."
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

# Database variables
variable "db_name" {
  description = "Name of the database to create"
  type        = string
  default     = "devdb"
}

variable "db_master_username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "13.7"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_storage_type" {
  description = "Storage type"
  type        = string
  default     = "gp3"
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 1
}

variable "db_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}


# Load Balancer Variables
variable "health_check_path" {
  description = "Health check path for ALB"
  type        = string
  default     = "/"
}

variable "enable_alb_deletion_protection" {
  description = "Enable deletion protection on ALB"
  type        = bool
  default     = false
}

variable "enable_alb_access_logs" {
  description = "Enable ALB access logs"
  type        = bool
  default     = false
}

# Compute Variables
variable "container_name" {
  description = "Container name"
  type        = string
  default     = "nginx"
}

variable "container_image" {
  description = "Container image"
  type        = string
  default     = "nginx:1.25.3-alpine"
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "container_environment" {
  description = "Container environment variables"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "task_cpu" {
  description = "Task CPU units"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Task memory in MB"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "enable_container_insights" {
  description = "Enable Container Insights"
  type        = bool
  default     = true
}

variable "enable_execute_command" {
  description = "Enable ECS Exec"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Log retention in days"
  type        = number
  default     = 7
}

variable "enable_autoscaling" {
  description = "Enable ECS auto-scaling"
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Minimum tasks for auto-scaling"
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum tasks for auto-scaling"
  type        = number
  default     = 4
}

variable "autoscaling_cpu_target" {
  description = "CPU target for auto-scaling"
  type        = number
  default     = 70
}

variable "autoscaling_memory_target" {
  description = "Memory target for auto-scaling"
  type        = number
  default     = 80
}
