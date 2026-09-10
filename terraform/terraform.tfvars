aws_region = "eu-west-2"

vpc_name = "my-gatus-vpc"

vpc_cidr = "10.0.0.0/16"

igw_name = "my-gatus-igw"

public_route_table_name = "my-gatus-public-rt"

public_subnets = {
  public-a = {
    cidr = "10.0.1.0/24"
    az   = "eu-west-2a"
  }

  public-b = {
    cidr = "10.0.2.0/24"
    az   = "eu-west-2b"
  }
}

alb_security_group_name = "my-gatus-alb-sg"

ecs_security_group_name = "my-gatus-ecs-sg"

repository_name = "my-gatus"

execution_role_name = "my-gatus-ecs-task-execution-role"

alb_name = "my-gatus-alb"

target_group_name = "my-gatus-target-group"

container_port = 8080

health_check_path = "/health"

health_check_matcher = "200"

cluster_name = "my-gatus-cluster"

task_role_name = "my-gatus-ecs-task-role"

domain_name = "tm.shuaybali.com"

log_group_name = "/ecs/my-gatus"

sns_topic_name = "my-gatus-alerts"

notification_email = "shuaybali007@hotmail.com"
