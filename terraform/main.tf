terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "floci-test/terraform.tfstate"
    region                      = "us-east-1"
    dynamodb_table              = "terraform-locks"

    endpoint                    = "http://localhost:4566"
    dynamodb_endpoint           = "http://localhost:4566"
    access_key                  = "test"
    secret_key                  = "test"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_region_validation      = true
    force_path_style            = true
 }
}

provider "aws" {
  region = "us-east-1"

  endpoints {
    s3     = "http://localhost:4566"
    sqs    = "http://localhost:4566"
    lambda = "http://localhost:4566"
    iam    = "http://localhost:4566"
  }

  access_key = "floci"
  secret_key = "floci"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  s3_use_path_style           = true
}

