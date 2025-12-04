variable "project_name" {
  type        = string
  description = "Project name for resource naming"
}

variable "environment" {
  type        = string
  description = "Environment (dev, staging, prod)"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "github_repository_name" {
  type        = string
  description = "GitHub repository name in format: owner/repo"
}

variable "ecr_repository_arn" {
  type        = string
  description = "ARN of the ECR repository"
}

variable "dynamodb_table_arn" {
  type        = string
  description = "ARN of the DynamoDB table"
}

variable "dynamodb_table_name" {
  type        = string
  description = "Name of the DynamoDB table"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}