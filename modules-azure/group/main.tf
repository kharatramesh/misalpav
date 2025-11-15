variable "rgname" {
  description = "The name of the resource group"
  type        = string
}   
variable "location" {
  description = "The location of the resource group"
  type        = string
}


resource "azurerm_resource_group" "main" {
  name     = var.rgname
  location = var.location
}

output "rgname1" {
  value = azurerm_resource_group.main.name
}
output "location1" {
  value = azurerm_resource_group.main.location
}
