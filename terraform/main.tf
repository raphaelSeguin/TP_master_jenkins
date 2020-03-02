resource "azurerm_resource_group" "rg" {
    name     = var.resource_group_name
    location = var.location 
}

resource "azurerm_virtual_network" "vnet" {
    name                = "mon_vn"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
    count                = var.machines_number
    name                 = "subnet${count.index}"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix       = "10.0.${count.index + 1}.0/24"
}

resource "azurerm_network_interface" "nic" {
    count                   = var.machines_number
    name                    = "nic${count.index}"
    location                = azurerm_resource_group.rg.location
    resource_group_name     = azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.subnet[count.index].id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          =  azurerm_public_ip.pub_ip.id   
    }
}

resource "azurerm_subnet_network_security_group_association" "secu_assoc1" {
  count                     = var.machines_number
  subnet_id                 = azurerm_subnet.subnet[count.index].id
  network_security_group_id = azurerm_network_security_group.secu.id
}
