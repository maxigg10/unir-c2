# Borramos la creación de red porque ya esta en network.tf. Solo la creamos una vez
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network


# Borramos la creación de subnet por lo mismo que describi mas arriba
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet



# Create NIC
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

resource "azurerm_network_interface" "myNic4" {
  name                = "vmnic4"  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "myipconfiguration4"
    subnet_id                      = azurerm_subnet.mySubnet.id 
    private_ip_address_allocation  = "Static"
    private_ip_address             = "10.0.1.13"
    public_ip_address_id           = azurerm_public_ip.myPublicIp4.id
  }

    tags = {
        environment = "CP2"
    }

}

# IP pública
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

resource "azurerm_public_ip" "myPublicIp4" {
  name                = "vmip4"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "CP2"
    }

}