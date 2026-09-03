variable "execution_role_name" {
  description = "Name of the ECS task execution role"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to IAM resources"
  type        = map(string)
}
