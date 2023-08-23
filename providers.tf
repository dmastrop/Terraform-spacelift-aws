terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  #region                  = "us-west-1"
  # don't use us-west-1. Keep original AWS dev_node in region us-west-1
  # run both setups simultaneously
  region               = "us-west-2"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "vscode"
}