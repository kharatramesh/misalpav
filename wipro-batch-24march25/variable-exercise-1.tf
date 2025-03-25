variable.tf
=============
variable "sid" {
  description = "value of subscription id"
  type        = string
  sensitive   = false
}
variable "cid" {
  description = "value of client id"
  type        = string
  sensitive   = true

}
variable "cs" {
  description = "value of client secret"
  type        = string
  sensitive   = true
}
variable "tid" {
  description = "value of tenant id"
  type        = string
  sensitive   = true
}

========================================
provider.tf


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.24.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = var.sid
  client_id       = var.cid
  client_secret   = var.cs
  tenant_id       = var.tid
}

========================================
rg.tf


locals {
  region                 = "Central India"
  name_of_resource_group = "wipro-rg1"
}

resource "azurerm_resource_group" "wipro1-rg1" {
  name     = local.name_of_resource_group
  location = local.region
}
