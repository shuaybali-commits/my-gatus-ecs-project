#Networking
module "vpc" {
  source = "./modules/vpc"

  vpc_name                = var.vpc_name
  vpc_cidr                = var.vpc_cidr
  igw_name                = var.igw_name
  public_route_table_name = var.public_route_table_name
  public_subnets          = var.public_subnets
  common_tags             = local.common_tags
}

#Security
module "security" {
  source = "./modules/security"

  vpc_id                  = module.vpc.vpc_id
  alb_security_group_name = var.alb_security_group_name
  ecs_security_group_name = var.ecs_security_group_name
  container_port          = var.container_port
  common_tags             = local.common_tags
}

#ECR
module "ecr" {
  source = "./modules/ecr"

  repository_name = var.repository_name
  common_tags     = local.common_tags
}

#IAM
module "iam" {
  source = "./modules/iam"

  execution_role_name = var.execution_role_name
  task_role_name      = var.task_role_name
  common_tags         = local.common_tags
}

#ACM
module "acm" {
  source = "./modules/acm"

  domain_name = var.domain_name
  common_tags = local.common_tags
}

#ALB
module "alb" {
  source = "./modules/alb"

  alb_name              = var.alb_name
  target_group_name     = var.target_group_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  certificate_arn       = module.acm.certificate_arn
  container_port        = var.container_port
  health_check_path     = var.health_check_path
  health_check_matcher  = var.health_check_matcher
  common_tags           = local.common_tags
}

#ECS
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
  log_group_name              = module.monitoring.log_group_name
  aws_region                  = var.aws_region

  common_tags = local.common_tags
}

#DNS
module "route53" {
  source = "./modules/route53"

  domain_name = var.domain_name

  alb_dns_name = module.alb.load_balancer_dns_name
  alb_zone_id  = module.alb.load_balancer_zone_id
}

#Monitoring
module "monitoring" {
  source = "./modules/monitoring"

  log_group_name     = var.log_group_name
  sns_topic_name     = var.sns_topic_name
  notification_email = var.notification_email
  cluster_name       = module.ecs.cluster_name
  service_name       = module.ecs.service_name
  common_tags        = local.common_tags
}
