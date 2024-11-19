terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "prod"
  assume_role {
    role_arn = "arn:aws:iam::830701124395:role/demo-role"
  }
}