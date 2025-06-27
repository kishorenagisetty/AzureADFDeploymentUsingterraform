resource "azurerm_virtual_network" "myVNet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "mysubnet" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.myVNet.name
  address_prefixes     = var.subnet_address_space
}