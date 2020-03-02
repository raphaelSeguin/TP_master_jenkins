
resource "azurerm_virtual_machine" "jenkinsVM" {
    count                   = var.machines_number
    name                    = var.machines_names[count.index]
    location                = azurerm_resource_group.rg.location
    resource_group_name     = azurerm_resource_group.rg.name
    network_interface_ids   = [azurerm_network_interface.nic[count.index].id]
    vm_size                 = "Standard_B1s"

    delete_os_disk_on_termination = true

    delete_data_disks_on_termination = true

    storage_os_disk {
        name              = "disque_${var.machines_names[count.index]}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    storage_image_reference {
        publisher = "OpenLogic"
        offer = "CentOS"
        sku = "7.6"
        version = "latest"
    } 
    os_profile {
        computer_name = var.machines_names[count.index]
        admin_username = "raphly"
    }
    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path = "/home/raphly/.ssh/authorized_keys"
            key_data = var.public_key
        }
    }
}
