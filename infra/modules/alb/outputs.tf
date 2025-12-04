output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "alb_security_group_id" {
  description = "Security group ID of the ALB"
  value       = aws_security_group.alb.id
}

output "blue_target_group_arn" {
  description = "ARN of the blue target group"
  value       = aws_lb_target_group.blue.arn
}

output "green_target_group_arn" {
  description = "ARN of the green target group"
  value       = aws_lb_target_group.green.arn
}

output "listener_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "blue_target_group_name" {
  value       = aws_lb_target_group.blue.name
  description = "Name of the blue target group"
}

output "green_target_group_name" {
  value       = aws_lb_target_group.green.name
  description = "Name of the green target group"
}