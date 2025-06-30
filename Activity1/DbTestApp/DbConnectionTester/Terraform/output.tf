output "vnet_ip_adress" {
  value = azurerm_virtual_network.b2.address_space
  description = "The public ip is "
}

output "pvt_ip_address" {
  value = azurerm_network_interface.b5.private_ip_address
}

output "web-url" {

  #value = "http://${aws_instance.web.public_ip}/preschool"

  value = "http://${azurerm_public_ip.b4.ip_address}/preschool"
  

}