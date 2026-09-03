variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to VPC resources"
  type        = map(string)
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


