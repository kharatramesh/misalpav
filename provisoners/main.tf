
variable "nsgrules" {
  type = list(map(any))
  default = [{ "rulename" = "sshrule", "priority" = "100", "dport" = "22", "protocol" = "Tcp" },
    { "rulename" = "httprule", "priority" = "101", "dport" = "80", "protocol" = "Tcp" },
    { "rulename" = "httpsrule", "priority" = "102", "dport" = "443", "protocol" = "Tcp" },
    { "rulename" = "dbrule", "priority" = "103", "dport" = "3306", "protocol" = "Tcp" },

  ]
}


module "rg_create_module" {
  source   = "../group"
  rgname   = "trainermyResourceGroup"
  location = "East US"
}

module "vnet_create_module" {
  source       = "../network"
  vnetname     = "trainer-example-vnet-1611"
  addressspace = ["21.21.21.0/24"]
  rgname       = module.rg_create_module.rgname1
  location     = module.rg_create_module.location1
}
resource "azurerm_subnet" "s1" {
  name                 = "s1"
  resource_group_name  = module.rg_create_module.rgname1
  virtual_network_name = module.vnet_create_module.vnetname1
  address_prefixes     = ["21.21.21.0/25"]
}

resource "azurerm_network_interface" "nic1" {
  name                = "nic1"
  resource_group_name = module.rg_create_module.rgname1
  location            = module.rg_create_module.location1
  ip_configuration {
    name                          = "ip1"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.s1.id
    public_ip_address_id          = azurerm_public_ip.pip1.id
  }
}

resource "azurerm_public_ip" "pip1" {
  name                = "pip1"
  resource_group_name = module.rg_create_module.rgname1
  location            = module.rg_create_module.location1
  allocation_method   = "Static"

}


resource "azurerm_network_security_group" "nsg1" {
  name                = "nsg1"
  resource_group_name = module.rg_create_module.rgname1
  location            = module.rg_create_module.location1
  dynamic "security_rule" {
    for_each = var.nsgrules
    content {
      name                       = security_rule.value.rulename
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = security_rule.value.protocol
      source_port_range          = "*"
      destination_port_range     = security_rule.value.dport
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}


resource "azurerm_network_interface_security_group_association" "assc1" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}


resource "azurerm_linux_virtual_machine" "vm1" {
  name                            = "vm1"
  resource_group_name             = module.rg_create_module.rgname1
  location                        = module.rg_create_module.location1
  size                            = "Standard_B1s"
  admin_username                  = "docker"
  admin_password                  = "Docker@12345"
  disable_password_authentication = false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    sku       = "22_04-lts"
    offer     = "0001-com-ubuntu-server-jammy"
    version   = "latest"
  }
  network_interface_ids = [azurerm_network_interface.nic1.id]

    provisioner "local-exec" {
        command = "echo VM Provisioned Successfully > index.html"
    }

    provisioner "file" {
        source      = "index.html"
        destination = "/tmp/index.html"
    }

    provisioner "file" {
        source      = "docker.sh"
        destination = "/tmp/docker.sh"

    }
    provisioner "remote-exec" {
        inline = [
        "sudo setfacl -m u:docker:rwx /var/www/html/",
        "sudo setfacl -m u:docker:rwx /tmp/",
        "sudo chmod +x /tmp/docker.sh",
        "sudo /tmp/docker.sh",
        "sudo cp /tmp/index.html /var/www/html/"
        ]
    }
    connection {
        type     = "ssh"
        user     = "docker"
        password = "Docker@12345"
        host     = azurerm_public_ip.pip1.ip_address
        timeout  = "3m"
  }

}
