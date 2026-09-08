variable "domain_name" {
  description = "Domain name for the ACM certificate"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to ACM resources"
  type        = map(string)
}

