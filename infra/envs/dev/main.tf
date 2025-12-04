data "aws_caller_identity" "current" {}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
  project_name         = var.project_name
  environment          = var.environment
}

module "vpc_endpoints" {
  source = "../../modules/vpc-endpoints"

  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  private_route_table_ids = [module.vpc.private_route_table_id] 
  vpc_cidr                = module.vpc.vpc_cidr_block
  project_name            = var.project_name
  region                  = var.aws_region
}

module "iam" {
  source = "../../modules/iam"
  
  project_name           = var.project_name
  environment            = var.environment
  aws_region            = var.aws_region
  github_repository_name = "AhmedMHCodeLab/ECS-V2-URL-SHORTNER" 
  
  ecr_repository_arn    = module.ecr.ecr_repository_arn
  dynamodb_table_arn = module.dynamodb.table_arn
  dynamodb_table_name   = "${var.project_name}-urls"
  ecs_cluster_name      = "${var.project_name}-cluster"
} 

module "dynamodb" {
  source = "../../modules/dynamodb"

  project_name = var.project_name
  environment  = var.environment
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}


module "alb" {
  source = "../../modules/alb"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  vpc_cidr           = module.vpc.vpc_cidr_block
}

module "cloudwatch_logs" {
  source = "../../modules/cloudwatch-logs"

  project_name       = var.project_name
  environment        = var.environment
  retention_in_days  = 7  # Short retention for dev
}

module "ecs" {
  source = "../../modules/ecs"

  project_name           = var.project_name
  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id
  private_subnet_ids     = module.vpc.private_subnet_ids
  alb_security_group_id  = module.alb.alb_security_group_id
  target_group_arn       = module.alb.blue_target_group_arn
  task_cpu               = 256
  task_memory            = 512
  container_name         = "url-shortener"
  # TODO: Change to git commit SHA when GitHub Actions is configured
  container_image        = "${module.ecr.ecr_repository_url}:latest"
  container_port         = 8080
  desired_count          = 1
  execution_role_arn     = module.iam.execution_role_arn
  task_role_arn          = module.iam.task_role_arn
  dynamodb_table_name    = module.dynamodb.table_name
  log_group_name         = module.cloudwatch_logs.log_group_name
  aws_region             = var.aws_region
}

# 10. CodeDeploy (depends on IAM, ECS, ALB)
module "codedeploy" {
  source = "../../modules/codedeploy"

  project_name            = var.project_name
  environment             = var.environment
  ecs_cluster_name        = module.ecs.cluster_name
  ecs_service_name        = module.ecs.service_name
  blue_target_group_name  = module.alb.blue_target_group_name
  green_target_group_name = module.alb.green_target_group_name
  alb_listener_arn        = module.alb.listener_arn
  codedeploy_role_arn     = module.iam.codedeploy_role_arn
}