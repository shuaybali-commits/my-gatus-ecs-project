variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "target_group_name" {
  description = "Name of the ALB target group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets used by the ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ID of the ALB security group"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to ALB resources"
  type        = map(string)
}

variable "container_port" {
  description = "Port the application container listens on"
  type        = number
}

variable "health_check_path" {
  description = "Path used by the ALB target group health check"
  type        = string
}

variable "health_check_matcher" {
  description = "Expected HTTP response code for a healthy target"
  type        = string
}
