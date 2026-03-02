output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.rds.id
}

output "db_instance_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.rds.arn
}

output "db_endpoint" {
  description = "Connection endpoint for the database"
  value       = aws_db_instance.rds.endpoint
}

output "db_address" {
  description = "Hostname of the RDS instance"
  value       = aws_db_instance.rds.address
}

output "db_port" {
  description = "Port of the database"
  value       = aws_db_instance.rds.port
}

output "db_name" {
  description = "Name of the database"
  value       = aws_db_instance.rds.db_name
}

output "db_username" {
  description = "Master username for the database"
  value       = aws_db_instance.rds.username
  sensitive   = true
}

output "security_group_id" {
  description = "Security group ID for RDS"
  value       = aws_security_group.database_sg.id
}

output "subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.subnet_group.name
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "secret_name" {
  description = "Name of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.db_credentials.name
}
