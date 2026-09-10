resource "aws_cloudwatch_log_group" "main" {
  name              = var.log_group_name
  retention_in_days = 30

  tags = merge(
    var.common_tags,
    {
      Name = var.log_group_name
    }
  )
}

resource "aws_sns_topic" "alerts" {
  name = var.sns_topic_name

  tags = merge(
    var.common_tags,
    {
      Name = var.sns_topic_name
    }
  )
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn

  protocol = "email"
  endpoint = var.notification_email
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "my-gatus-ecs-high-cpu"
  alarm_description   = "Triggers when ECS CPU exceeds 80%"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  tags = merge(
    var.common_tags,
    {
      Name = "my-gatus-ecs-high-cpu"
    }
  )
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory_high" {
  alarm_name        = "my-gatus-ecs-high-memory"
  alarm_description = "Triggers when ECS memory exceeds 80%"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  tags = merge(
    var.common_tags,
    {
      Name = "my-gatus-ecs-high-memory"
    }
  )
}

