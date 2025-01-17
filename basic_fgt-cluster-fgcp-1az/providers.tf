##############################################################################################################
# Terraform Providers
##############################################################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = ""
    key            = ""
    region         = ""
    dynamodb_table = "" # Optional for state locking
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
