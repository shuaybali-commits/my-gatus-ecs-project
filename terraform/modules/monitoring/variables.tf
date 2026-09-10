variable "log_group_name" {
  description = "CloudWatch Log Group name"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to monitoring resources"
  type        = map(string)
}

variable "sns_topic_name" {
  description = "Name of the SNS topic"
  type        = string
}

variable "notification_email" {
  description = "Email address that receives CloudWatch alarms"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}
