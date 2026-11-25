terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.74.0"
    }

  }
}
provider "aws" {
  # Configuration options

  access_key = var.akey
  secret_key = var.skey
  region     = var.location
}

