#calling module
module "rg_create_module" {
  source   = "../group"
  rgname   = "trainer-example-resource-group-1611"
  location = "East US"
}



module "vnet_create_module" {
  source       = "../network"
  vnetname     = "trainer-example-vnet-1611"
  addressspace = ["21.21.21.0/24"]
  rgname       = module.rg_create_module.rgname1
  location     = module.rg_create_module.location1
}

module "vnet_create_module1" {
  source       = "../network"
  vnetname     = "trainer1-example1-vnet1-1611"
  addressspace = ["22.22.22.0/24"]
  rgname       = module.rg_create_module.rgname1
  location     = module.rg_create_module.location1
}
