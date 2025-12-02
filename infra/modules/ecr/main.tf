resource "aws_ecr_repository" "repository" {
  name = "${var.project_name}-repository"
  image_tag_mutability = "MUTABLE"
  encryption_configuration { 
    encryption_type = "AES256"
  }
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.project_name}-repository"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
    repository = aws_ecr_repository.repository.name
    
   policy = jsonencode({
  rules = [
    {
      rulePriority = 1
      description  = "Keep last 10 images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
      action = {
        type = "expire"
      }
    }
  ]
})
  
}