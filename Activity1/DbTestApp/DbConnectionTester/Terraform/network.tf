# Virtual_Network 

resource "azurerm_virtual_network" "b2" {
  location            = azurerm_resource_group.b1.location
  resource_group_name = azurerm_resource_group.b1.name
  name                = var.vnet_name
  address_space       = var.vnet_ip #["10.0.0.0/16"]
  depends_on = [ azurerm_resource_group.b1 ]
}

# subnets

resource "azurerm_subnet" "b3" {
  count                = length(var.subnet_names)
  virtual_network_name = azurerm_virtual_network.b2.name
  resource_group_name  = azurerm_resource_group.b1.name
  name                 = var.subnet_names[count.index] #"subnet1"
  address_prefixes     = [var.subnet_ips[count.index]] #[ "10.0.0.0/24" ]
  depends_on = [ azurerm_virtual_network.b2 ]
}

resource "azurerm_network_security_group" "b3" {
  resource_group_name = azurerm_resource_group.b1.name
  location            = azurerm_resource_group.b1.location
  name                = var.nsg_name #"NSg1"
depends_on = [ azurerm_virtual_network.b2 ]
}

resource "azurerm_network_security_rule" "b7" {
  resource_group_name         = azurerm_resource_group.b1.name
  network_security_group_name = azurerm_network_security_group.b3.name
  name                        = var.sec_rule.name                       #"Rule1"
  priority                    = var.sec_rule.priority                   #"100"
  access                      = var.sec_rule.access                     #"Allow"
  protocol                    = var.sec_rule.protocol                   # "Tcp"
  direction                   = var.sec_rule.direction                  #"Inbound"
  source_address_prefix       = var.sec_rule.source_address_prefix      #"*"
  destination_address_prefix  = var.sec_rule.destination_address_prefix #"*"
  source_port_range           = var.sec_rule.source_port_range          #"*"
  destination_port_range      = var.sec_rule.destination_port_range     #"*"
depends_on = [ azurerm_network_security_group.b3 ]
}

resource "azurerm_public_ip" "b4" {
  resource_group_name = azurerm_resource_group.b1.name
  location            = azurerm_resource_group.b1.location
  name                = var.public_ip_name    # "P_ip1"
  allocation_method   = var.allocation_method #"Dynamic"
  sku                 = var.sku # Basic
  depends_on = [ azurerm_virtual_network.b2, azurerm_subnet.b3, azurerm_network_security_group.b3 ]
}

resource "azurerm_network_interface" "b5" {
  resource_group_name = azurerm_resource_group.b1.name
  location            = azurerm_resource_group.b1.location
  name                = var.nic_name #"NIC1"
  ip_configuration {
    subnet_id                     = azurerm_subnet.b3[0].id
    private_ip_address_allocation = var.pvt_ip_all #"Dynamic"
    name                          = "internal"
    public_ip_address_id          = azurerm_public_ip.b4.id
  }
  depends_on = [azurerm_public_ip.b4]
}

resource "azurerm_linux_virtual_machine" "b6" {
  resource_group_name = azurerm_resource_group.b1.name
  location            = azurerm_resource_group.b1.location
  name                = var.vm_info.vm_name      #"VM1"
  size                = var.vm_info.vm_size      #"Standard_B1s"
  admin_username      = var.vm_info.vm_admin_usr #"Aravindh"
  admin_ssh_key {
    username   = var.vm_info.vm_admin_usr   #"Aravindh"
    public_key = file(var.vm_info.key_path) #"~/.ssh/id_rsa.pub"
  }
  source_image_reference {
    publisher = var.vm_info.vm_publisher #"canonical"
    offer     = var.vm_info.vm_offer     #"0001-com-ubuntu-server-jammy"
    sku       = var.vm_info.vm_sku       #"22_04-lts-gen2"
    version   = var.vm_info.vm_version   #"latest"
  }
  network_interface_ids = [azurerm_network_interface.b5.id]
  os_disk {
    storage_account_type = var.vm_info.storage_type #"Standard_LRS"
    caching              = var.vm_info.vm_caching   #"ReadWrite"
  }


  custom_data = base64encode(file("install.sh"))
  depends_on  = [azurerm_public_ip.b4, azurerm_network_interface.b5,azurerm_network_security_group.b3]
}




