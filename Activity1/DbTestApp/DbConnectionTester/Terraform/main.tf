# Resource group

resource "azurerm_resource_group" "b1" {
  name     = "Aravindh"
  location = "eastus"
}
output "public_ip_address" {
  value = azurerm_public_ip.b4.ip_address
}
