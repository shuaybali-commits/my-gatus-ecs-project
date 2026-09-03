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
