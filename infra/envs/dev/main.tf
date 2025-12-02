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
  aws_region            = var.aws_region
  github_repository_name = "AhmedMHCodeLab/ECS-V2-URL-SHORTNER" 
  
  ecr_repository_arn    = "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/${var.project_name}"
  dynamodb_table_arn    = "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/${var.project_name}-urls"
  dynamodb_table_name   = "${var.project_name}-urls"
  ecs_cluster_name      = "${var.project_name}-cluster"
} 
