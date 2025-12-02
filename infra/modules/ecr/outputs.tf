output "ecr_repository_arn" {
  value = aws_ecr_repository.repository.arn
  description = "ARN of the ECR repository"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.repository.repository_url
  description = "URL of the ECR repository"
}