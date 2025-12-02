output "task_role_arn" {
  description = "ARN of the IAM Role for ECS Tasks"
  value       = aws_iam_role.task_role.arn
}

output "execution_role_arn" {
  description = "ARN of the IAM Role for ECS Task Execution"
  value       = aws_iam_role.execution_role.arn
}

output "github_oidc_role_arn" {
  description = "ARN of the IAM Role for GitHub OIDC App Deployment"
  value       = aws_iam_role.github_oidc_role.arn
}

output "github_oidc_terraform_role_arn" {
  description = "ARN of the IAM Role for GitHub OIDC Terraform Deployment"
  value       = aws_iam_role.github_oidc_terraform_role.arn
}
