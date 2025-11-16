terraform workspace list
terraform workspace new dev
terraform workspace new uat
terraform workspace new prod

terraform workspace select dev

terraform fmt
terraform validate
terraform plan
terraform apply

terraform workspace select uat

terraform workspace delete uat





=========================================
resource "azurerm_resource_group" "example" {
  name     = "rg-xyz-${terraform.workspace}"
  location = "eastus"
}

resource "azurerm_virtual_network" "example1" {
  name = "vnet-xyz-${terraform.workspace}"
  #   address_space       = ["11.11.11.0/24"]
  address_space       = ["12.12.12.0/24"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
