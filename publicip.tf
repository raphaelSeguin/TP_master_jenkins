resource "azurerm_public_ip" "pub_ip" {
    name                = "ip_pub"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"
    domain_name_label   = "pilecomplete"
}