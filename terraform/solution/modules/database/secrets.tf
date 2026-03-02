
# AWS Secrets Manager secret for database credentials
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "${var.environment}-${var.service}-db-credentials"
  description             = "Database credentials for ${var.environment} ${var.service}"
  recovery_window_in_days = var.environment == "prod" ? 30 : 7

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.service}-db-credentials"
    }
  )
}

# Store the credentials in Secrets Manager
resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({
    username = var.db_master_username
    password = random_password.db_password.result
    engine   = var.db_engine
    host     = aws_db_instance.rds.address
    port     = aws_db_instance.rds.port
    dbname   = var.db_name
  })
}
