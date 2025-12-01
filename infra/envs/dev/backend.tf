terraform {
  backend "s3" {
    bucket         = "ecsv2-tfstate-590183934190"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ecsv2-tfstate-locks"
    encrypt        = true
  }
}