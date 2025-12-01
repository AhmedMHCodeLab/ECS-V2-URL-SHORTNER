output "vpc_endpoint_security_group_id" {
  description = "Security group ID for VPC endpoints"
  value       = aws_security_group.vpc_endpoints_sg.id
}

output "ecr_api_endpoint_id" {
  description = "VPC endpoint ID for ECR API"
  value       = aws_vpc_endpoint.ecr_api.id
}

output "ecr_dkr_endpoint_id" {
  description = "VPC endpoint ID for ECR DKR"
  value       = aws_vpc_endpoint.ecr_dkr.id
}

output "logs_endpoint_id" {
  description = "VPC endpoint ID for CloudWatch Logs"
  value       = aws_vpc_endpoint.cloudwatch_logs.id
}

output "sts_endpoint_id" {
  description = "VPC endpoint ID for STS"
  value       = aws_vpc_endpoint.sts.id
}

output "s3_endpoint_id" {
  description = "VPC endpoint ID for S3"
  value       = aws_vpc_endpoint.s3.id
}

output "dynamodb_endpoint_id" {
  description = "VPC endpoint ID for DynamoDB"
  value       = aws_vpc_endpoint.dynamodb.id
}