resource "aws_dynamodb_table" "urls" {
  name         = "${var.project_name}-urls"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "short_code"

  attribute {
    name = "short_code"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name        = "${var.project_name}-urls-table"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}