terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "dosa" {
  name     = var.groupname
  location = var.region
}

resource "azurerm_virtual_network" "dosa-net" {
  resource_group_name = azurerm_resource_group.dosa.name
  location            = azurerm_resource_group.dosa.location
  name                = var.name
  address_space       = var.address
}
resource "azurerm_subnet" "dosa-s1" {
  name                 = "subnet1-${var.name}"
  address_prefixes     = [var.subnets[0]]
  virtual_network_name = azurerm_virtual_network.dosa-net.name
  resource_group_name  = azurerm_resource_group.dosa.name
}
resource "azurerm_subnet" "dosa-s2" {
  name                 = "subnet2-${var.name}"
  address_prefixes     = [var.subnets[1]]
  virtual_network_name = azurerm_virtual_network.dosa-net.name
  resource_group_name  = azurerm_resource_group.dosa.name
}

resource "azurerm_public_ip" "dosa-publicip" {
  count               = var.machines
  name                = "publicip-${var.names[count.index]}"
  location            = azurerm_resource_group.dosa.location
  resource_group_name = azurerm_resource_group.dosa.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "dosa-nic" {
  count               = var.machines
  name                = "nic-${var.names[count.index]}"
  location            = var.region
  resource_group_name = azurerm_resource_group.dosa.name
  ip_configuration {
    name                          = "ip-${var.names[count.index]}"
    subnet_id                     = azurerm_subnet.dosa-s1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.dosa-publicip.*.id, count.index)
  }
}

resource "azurerm_linux_virtual_machine" "dosa-vm1" {
  name                            = "vm-${var.names[count.index]}"
  resource_group_name             = azurerm_resource_group.dosa.name
  location                        = azurerm_resource_group.dosa.location
  disable_password_authentication = false
  admin_username                  = "hexagon"
  admin_password                  = "Hexagon@123"
  size                            = "Standard_B1ms"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  count               = var.machines
  network_interface_ids = [element(azurerm_network_interface.dosa-nic.*.id, count.index)]
}

