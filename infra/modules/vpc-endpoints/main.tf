resource "aws_security_group" "vpc_endpoints_sg" {
  name        = "${var.project_name}-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow HTTPS traffic from within the VPC"
  }

  # won't specify egress block at all 
}

#ill use this for docker auth, cause without it i cant pull images from ECR
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints_sg.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}-ecr-api-endpoint"
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}  

#ill use this for Image manifests & metadata, cause without it i cant  get the list of layers to pull
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints_sg.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}-ecr-dkr-endpoint"
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

#ill use logs cause without them i can't see what the app is doing (blind debugging)
resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints_sg.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}-cloudwatch-logs-endpoint"
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}


#ill use STS cause without it i can'tassume roles
resource "aws_vpc_endpoint" "sts" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpc_endpoints_sg.id]
  private_dns_enabled = true

  tags = {
    Name        = "${var.project_name}-sts-endpoint"
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}



resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids 

  tags = {
    Name        = "${var.project_name}-s3-endpoint"
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.private_route_table_ids 

  tags = {
    Name        = "${var.project_name}-dynamodb-endpoint"
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}