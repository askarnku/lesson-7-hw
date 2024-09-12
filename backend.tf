terraform {
  required_version = "~>1.9"
  backend "s3" {
    bucket         = "askar-backend"
    region         = "us-east-1"
    key            = "lesson-7-hw"
    dynamodb_table = "lesson7-hw"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
  }
}

#Good practice to build dynamo_db table location. Is it in backend block?
resource "aws_dynamodb_table" "terraform_locking" {
  name         = "lesson7-hw"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

