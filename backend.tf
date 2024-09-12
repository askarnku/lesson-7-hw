terraform {
  required_version = "~>1.9"
  backend "s3" {
    bucket         = "askar-backend"
    region         = "us-east-1"
    key            = "lesson-7-hw"
    dynamodb_table = "state-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
  }
}

provider "aws" {
  profile = "defalut"
  region  = "us-east-1"
}

