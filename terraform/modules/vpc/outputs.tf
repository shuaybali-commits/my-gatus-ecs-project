output "vpc_id" {
  description = "ID of the VPC"

  value = aws_vpc.main.id
}

output "public_subnet_ids" {
    description = "IDs of the public subnets"

    value = [
        for subnet in aws_subnet.public : subnet.id
    ]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"

  value = aws_internet_gateway.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"

  value = aws_vpc.main.cidr_block
}


