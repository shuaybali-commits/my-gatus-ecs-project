module "vpc" {
  source = "./modules/vpc"

  vpc_name                = var.vpc_name
  vpc_cidr                = var.vpc_cidr
  igw_name                = var.igw_name
  public_route_table_name = var.public_route_table_name
  public_subnets          = var.public_subnets

  common_tags = local.common_tags
}


