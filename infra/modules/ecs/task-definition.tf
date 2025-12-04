resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  
  # IAM roles
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  # Container definition
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true
      
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "TABLE_NAME"
          value = var.dynamodb_table_name
        },
        {
          name  = "AWS_DEFAULT_REGION"
          value = var.aws_region
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = var.log_group_name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

     
    }
  ])

  tags = {
    Name        = "${var.project_name}-task-definition"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}