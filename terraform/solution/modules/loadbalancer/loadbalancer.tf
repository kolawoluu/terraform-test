# Application Load Balancer
resource "aws_lb" "nginx_alb" {
  name               = "${var.environment}-${var.service}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nginx_alb_sg.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  enable_http2               = true

  enable_cross_zone_load_balancing = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.service}-alb"
    }
  )
}

# Security Group for ALB
resource "aws_security_group" "nginx_alb_sg" {
  name        = "${var.environment}-${var.service}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.service}-alb-sg"
    }
  )
}

# Target Group
resource "aws_lb_target_group" "nginx_target_group" {
  name        = "${var.environment}-${var.service}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip" # Required for Fargate awsvpc mode

  health_check {
    path = "/"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-${var.service}-tg"
    }
  )
}

# HTTP Listener (forward to target group on port 80; no HTTPS without ACM certificate)
resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
  }
}
