resource "aws_lb" "main" {
  name = var.alb_name
  internal = false
  load_balancer_type = "application"
  security_groups = [var.alb_security_group_id]
  subnets = var.public_subnet_ids
  enable_deletion_protection = true

  tags = merge(
    var.common_tags,
    {
      Name = var.alb_name
    }
  )
}

resource "aws_lb_target_group" "main" {
  name = var.target_group_name
  port     = var.container_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"

health_check {
  enabled = true
  path = var.health_check_path
  protocol = "HTTP"
  matcher = var.health_check_matcher
  interval = 30
  timeout = 5
  healthy_threshold = 3
  unhealthy_threshold = 3
}

  tags = merge(
    var.common_tags,
    {
      Name = var.target_group_name
    }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn

  port     = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
