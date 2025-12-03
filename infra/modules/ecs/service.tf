resource "aws_ecs_service" "app" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_task.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  # Deployment configuration - top-level attributes
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  # Circuit breaker for automatic rollback
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  # Health check grace period
  health_check_grace_period_seconds = 60

  # Ignore changes to desired_count and task_definition
  # desired_count: managed by auto-scaling
  # task_definition: managed by CodeDeploy (will add later)
  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  tags = {
    Name        = "${var.project_name}-ecs-service"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}