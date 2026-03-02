# DB Subnet Group
resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.environment}-${var.service}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.service}-db-subnet-group"
    }
  )
}


# RDS Instance
resource "aws_db_instance" "rds" {
  identifier     = "${var.environment}-${var.service}-db"
  engine         = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class

  allocated_storage = var.db_allocated_storage
  storage_type      = var.db_storage_type
  storage_encrypted = true
  kms_key_id        = aws_kms_key.db_key.arn

  db_name  = var.db_name
  username = var.db_master_username
  password = random_password.db_password.result
  port     = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids = [aws_security_group.database_sg.id]
  publicly_accessible    = false

  multi_az          = var.db_multi_az
  availability_zone = var.db_multi_az ? null : var.db_availability_zone

  backup_retention_period = var.db_backup_retention_period
  backup_window           = var.db_backup_window
  maintenance_window      = var.db_maintenance_window

  deletion_protection       = var.db_deletion_protection
  skip_final_snapshot       = var.environment != "prod"
  final_snapshot_identifier = var.environment == "prod" ? "${var.environment}-${var.service}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}" : null

  auto_minor_version_upgrade = var.db_auto_minor_version_upgrade

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.service}-db"
    }
  )
}

resource "aws_kms_key" "db_key" {
  description         = "KMS key for RDS database"
  enable_key_rotation = true
  tags                = var.common_tags
}