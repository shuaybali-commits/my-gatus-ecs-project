resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  tags = merge(
    var.common_tags,
    {
      Name = var.cluster_name
    }
  )
}

resource "aws_ecs_task_definition" "main" {
  family                   = "my-gatus"
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = 256
  memory = 512

  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn = var.task_role_arn

runtime_platform {
  operating_system_family = "LINUX"
  cpu_architecture        = "ARM64"
}

  container_definitions = jsonencode([
    {
      name      = "gatus"
      image     = "${var.repository_url}:v1"
      essential = true

      portMappings = [
      {
        containerPort = var.container_port
        hostPort      = var.container_port
        protocol      = "tcp"
      }
      ]
    }
  ])

  tags = merge(
    var.common_tags,
    {
      Name = "my-gatus-task"
    }
  )
}

resource "aws_ecs_service" "main" {
  name = "my-gatus-service"

  cluster = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count = 1

  launch_type = "FARGATE"

    enable_execute_command = true

  network_configuration {
    subnets = var.public_subnet_ids

    security_groups = [var.ecs_security_group_id]

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name = "gatus"
    container_port = var.container_port
  }

  # Allow CI/CD to deploy new task definition revisions without Terraform trying to roll them back.
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  tags = merge(
  var.common_tags,
  {
    Name = "my-gatus-service"
  }
  )

}
