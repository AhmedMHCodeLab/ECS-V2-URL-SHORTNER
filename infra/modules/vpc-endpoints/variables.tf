
variable "vpc_id" {
  description = "The ID of the VPC where endpoints will be created."
  type        = string
}
variable "private_subnet_ids" {
  description = "A list of private subnet IDs where endpoint ENIs will be placed."
  type        = list(string)
}
variable "private_route_table_ids" {
  description = "A list of private route table IDs for gateway endpoints."
  type        = list(string)
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC for security group rules."
  type        = string
}

variable "project_name" {
  description = "The name of the project or environment for tagging resources."
  type        = string
}

variable "region" {
  description = "The AWS region where the VPC and endpoints are located."
  type        = string
}