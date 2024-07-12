terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.56.1"
    }
  }
}

provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "ap-south-1"
}

resource "aws_s3_bucket" "samosa-bucket-wipro" {
  bucket = "vadapav11-wipro11-india"
  tags = {
    name     = "vadapav1-wipro1-india"
    env      = "dev"
    location = "mumbai-kharghar"
  }
}

