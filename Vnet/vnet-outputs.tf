output "VNetName" {
  value = azurerm_virtual_network.myVNet.name
}
output "VNetID" {
  value = azurerm_virtual_network.myVNet.id
}
output "subnetName" {
  value = azurerm_subnet.mysubnet.name
}
output "subnetID" {
  value = azurerm_subnet.mysubnet.id
}