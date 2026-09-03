variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to ECR resources"
  type        = map(string)
}
