resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = var.retention_in_days

  tags = {
    Name        = "${var.project_name}-ecs-logs"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}