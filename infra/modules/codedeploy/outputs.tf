output "codedeploy_app_name" {
  value       = aws_codedeploy_app.app.name
  description = "Name of the CodeDeploy application"
}

output "codedeploy_deployment_group_name" {
  value       = aws_codedeploy_deployment_group.group.deployment_group_name
  description = "Name of the CodeDeploy deployment group"
}