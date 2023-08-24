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

  # add the aws_region ENV variable in spacelift to both linux context and windows context
  # for my setup us-west-2 will be used for linux and us-east-1 for windows.
  # comment out the region below....
  ##region               = "us-west-2"
  # ... and add as a variable
  region = var.aws_region

  shared_credentials_file = "~/.aws/credentials"
  profile                 = "vscode"
}