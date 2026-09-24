######### Providers details #########
terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  #  ######### Details for HCP remote backend #########
  backend "remote" {
    organization = "my-tf-learning"
    workspaces {
      name = "terraform-prod"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
