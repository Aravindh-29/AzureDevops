vnet_name         = "Vnet2"
vnet_ip           = ["10.0.0.0/16"]
subnet_names      = ["web", "db"]
subnet_ips        = ["10.0.0.0/24", "10.0.1.0/24"]
nsg_name          = "Nsg2"
public_ip_name    = "P_ip2"
allocation_method = "Dynamic"
sku = "Basic"
nic_name          = "NIc2"
pvt_ip_all        = "Dynamic"
vm_info = {
  vm_name      = "VM1"
  vm_size      = "Standard_B1s"
  vm_admin_usr = "Aravindh"
  key_path     = "~/.ssh/id_ed25519.pub"
  vm_publisher = "canonical"
  vm_offer     = "0001-com-ubuntu-server-jammy"
  vm_sku       = "22_04-lts-gen2"
  vm_version   = "latest"
  storage_type = "Standard_LRS"
  vm_caching   = "ReadWrite"
}

sec_rule = {

  name                       = "Rule1"
  priority                   = "100"
  access                     = "Allow"
  protocol                   = "Tcp"
  direction                  = "Inbound"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  source_port_range          = "*"
  destination_port_range     = "*"

}