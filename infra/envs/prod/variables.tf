variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "ecs-v2-url-shortener"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}
