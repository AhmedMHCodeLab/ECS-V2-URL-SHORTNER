variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for Task Role permissions"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table for Task Role resource restriction"
  type        = string
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository for Execution Role and GitHub OIDC App role"
  type        = string
}

variable "github_repository_name" {
  description = "Name of the GitHub repository for OIDC trust policy"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster for GitHub OIDC App role"
  type        = string
}

variable "project_name" {
  description = "The name of the project or environment for tagging resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region for resource ARNs"
  type        = string
}
