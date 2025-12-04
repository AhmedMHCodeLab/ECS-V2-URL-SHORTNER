variable "project_name" {
  type        = string
  description = "Project name for resource naming"
}

variable "environment" {
  type        = string
  description = "Environment (dev, staging, prod)"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "ecs_service_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "blue_target_group_name" {
  type        = string
  description = "Name of the blue target group"
}

variable "green_target_group_name" {
  type        = string
  description = "Name of the green target group"
}

variable "alb_listener_arn" {
  type        = string
  description = "ARN of the ALB listener"
}

variable "codedeploy_role_arn" {
  type        = string
  description = "ARN of the IAM role for CodeDeploy"
}