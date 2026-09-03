variable "vpc_id" {
  description = "ID of the VPC where the security groups will be created"
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

variable "common_tags" {
  description = "Common tags applied to security resources"
  type        = map(string)
}


