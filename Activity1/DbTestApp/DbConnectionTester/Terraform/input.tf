variable "vnet_name" {
  type = string
}
variable "vnet_ip" {
  type = list(string)
}

variable "subnet_names" {
  type = list(string)
}

variable "subnet_ips" {
  type = list(string)
}

variable "nsg_name" {
  type = string
}
variable "public_ip_name" {
  type = string
}
variable "allocation_method" {
  type = string
}
variable "sku" {
  type = string
}

variable "nic_name" {
  type = string
}
variable "pvt_ip_all" {
  type = string
}

variable "vm_info" {
  type = object({
    vm_name      = string
    vm_size      = string
    vm_admin_usr = string
    key_path     = string
    vm_publisher = string
    vm_offer     = string
    vm_sku       = string
    vm_version   = string
    storage_type = string
    vm_caching   = string
  })

}

variable "sec_rule" {
  type = object({
    name                       = string
    priority                   = string
    access                     = string
    protocol                   = string
    direction                  = string
    source_address_prefix      = string
    destination_address_prefix = string
    source_port_range          = string
    destination_port_range     = string
  })
}