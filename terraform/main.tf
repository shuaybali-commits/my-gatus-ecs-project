module "vpc" {
  source = "./modules/vpc"

  vpc_name                = var.vpc_name
  vpc_cidr                = var.vpc_cidr
  igw_name                = var.igw_name
  public_route_table_name = var.public_route_table_name
  public_subnets          = var.public_subnets
  common_tags             = local.common_tags
}

module "security" {
  source = "./modules/security"

  vpc_id                  = module.vpc.vpc_id
  alb_security_group_name = var.alb_security_group_name
  ecs_security_group_name = var.ecs_security_group_name
  common_tags             = local.common_tags
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = var.repository_name
  common_tags     = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  execution_role_name = var.execution_role_name
  task_role_name      = var.task_role_name
  common_tags         = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  alb_name              = var.alb_name
  target_group_name     = var.target_group_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  container_port        = var.container_port
  health_check_path     = var.health_check_path
  health_check_matcher  = var.health_check_matcher
  common_tags           = local.common_tags
}

module "ecs" {
  source = "./modules/ecs"

  cluster_name                = var.cluster_name
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn               = module.iam.ecs_task_role_arn
  repository_url              = module.ecr.repository_url
  public_subnet_ids           = module.vpc.public_subnet_ids
  ecs_security_group_id       = module.security.ecs_security_group_id
  target_group_arn            = module.alb.target_group_arn
  container_port              = var.container_port

  common_tags = local.common_tags
}

module "acm" {
  source = "./modules/acm"

  domain_name = var.domain_name
  common_tags = local.common_tags
}


