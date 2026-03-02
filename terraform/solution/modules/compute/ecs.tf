# ECS Cluster
resource "aws_ecs_cluster" "nginx_cluster" {
  name = "${var.environment}-nginx-cluster"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-nginx-cluster"
    }
  )
}

# ECS Task Definition
resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "${var.environment}-nginx-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu                = var.task_cpu
  memory             = var.task_memory
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]

      environment = var.container_environment

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-nginx-task"
    }
  )
}

# ECS Service
resource "aws_ecs_service" "nginx_service" {
  name            = "${var.environment}-${var.service}"
  cluster         = aws_ecs_cluster.nginx_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn

  launch_type      = "FARGATE"
  desired_count    = var.desired_count

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-nginx-service"
    }
  )

  depends_on = [
    aws_iam_role_policy_attachment.ecs_execution_role_policy, aws_ecs_task_definition.nginx_task
  ]

}
