resource "azurerm_virtual_network" "vnet-atividade" {
  name                = "vnet-atividade"
  location            = azurerm_resource_group.rg-atividade.location
  resource_group_name = azurerm_resource_group.rg-atividade.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    faculdade = "Impacta"
  }
}

resource "azurerm_subnet" "sub-atividade" {
  name                 = "sub-atividade"
  resource_group_name  = azurerm_resource_group.rg-atividade.name
  virtual_network_name = azurerm_virtual_network.vnet-atividade.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg-atividade" {
  name                = "nsg-atividade"
  location            = azurerm_resource_group.rg-atividade.location
  resource_group_name = azurerm_resource_group.rg-atividade.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Web"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    faculdade = "Impacta"
  }
}
