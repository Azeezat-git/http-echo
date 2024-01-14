terraform {
  backend "s3" {
    bucket         = "zee-remote-state"
    key            = "zee/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}


provider "aws" {
    region = "us-east-1"
}
