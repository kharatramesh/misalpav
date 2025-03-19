terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.23.0"
    }

    aws = {
      source = "hashicorp/aws"
      version = "5.91.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  alias      = "azure1"
  subscription_id = "32b495-0c5b40426f38"
  features {
  }

}

provider "aws" {
  alias      = "aws1"
  access_key = var.akey
  secret_key = var.skey
  region     = "ap-south-1"
}


resource "azurerm_resource_group" "rgazure" {
  provider = azurerm.azure1
  name     = "rg11azure"
  location = "eastus"
}

resource "aws_s3_bucket" "s31" {
  provider = aws.aws1
  bucket = "vadapavsamosa-sg1"
}
