resource "aws_security_group" "alb" {
  name        = var.alb_security_group_name
  description = "Security group for the Application Load Balancer"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = var.alb_security_group_name
    }
  )
}

resource "aws_security_group" "ecs" {
  name        = var.ecs_security_group_name
  description = "Security group for the ECS service"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = var.ecs_security_group_name
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_ingress" {
  security_group_id = aws_security_group.alb.id
  description = "Allow HTTP traffic from the internet"
  from_port = 80
  to_port   = 80
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_ingress" {
  security_group_id = aws_security_group.alb.id
  description = "Allow HTTPS traffic from the internet"
  from_port = 443
  to_port   = 443
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_egress" {
  security_group_id = aws_security_group.alb.id
  description = "Allow all outbound traffic"
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ecs_ingress" {
  security_group_id = aws_security_group.ecs.id
  description = "Allow TCP 8080 traffic from the ALB security group"
  from_port = 8080
  to_port   = 8080
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "ecs_egress" {
  security_group_id = aws_security_group.ecs.id
  description = "Allow all outbound traffic"
  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}
