variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
}

variable "public_subnets" {
  description = "Configuration for the public subnets"

  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "public_route_table_name" {
  description = "Name tag for the public route table"
  type        = string
}

variable "alb_security_group_name" {
  description = "Name tag for the ALB security group"
  type        = string
}

variable "ecs_security_group_name" {
  description = "Name tag for the ECS security group"
  type        = string
}

variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "execution_role_name" {
  description = "Name of the ECS task execution role"
  type        = string
}

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "target_group_name" {
  description = "Name of the ALB target group"
  type        = string
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

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "task_role_name" {
  description = "Name of the ECS task role"
  type        = string
}

