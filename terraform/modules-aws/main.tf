terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.57.0"
    }
  }
}


terraform {
  backend "s3" {
    bucket         = "trainer-s3-remote-backend-for-modules-1107"
    key            = "wipro-project/modules2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "wipro-trainer-dynamodb-lock1-1107"
  }
}

provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "ap-south-1"
}

module "jalebi" {
    source = ".//m1"
    itype = "t2.medium"
    image = "ami-0ec0e125bb6c6e8ec"
    webfile = "web22.sh"
    name ="panipuri"
    index = "biryani.html"
}
