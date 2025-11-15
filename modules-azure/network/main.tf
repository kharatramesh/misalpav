resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnetname
  address_space       = var.addressspace
  location            = var.location
  resource_group_name = var.rgname
}


variable "vnetname" {type = string}
variable "addressspace" {type = list(string)}
variable "location" {type = string}
variable "rgname" {type = string}
