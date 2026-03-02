# CloudWatch Log Group for ECS Tasks
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.environment}/nginx"
  retention_in_days = var.log_retention_days

  tags = var.common_tags
}