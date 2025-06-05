resource "azurerm_virtual_network" "aks_wakaran" {
  name                = local.vnet_name
  location            = azurerm_resource_group.aks_wakaran.location
  resource_group_name = azurerm_resource_group.aks_wakaran.name
  address_space       = ["10.0.0.0/8"]

  tags = local.project_tags
}

resource "azurerm_subnet" "aks" {
  name                 = local.snet_aks_name
  resource_group_name  = azurerm_resource_group.aks_wakaran.name
  virtual_network_name = azurerm_virtual_network.aks_wakaran.name
  address_prefixes     = ["10.240.0.0/16"]

  # サブネットには tags 属性がありません
}

resource "azurerm_network_security_group" "aks" {
  name                = "nsg-aks"
  location            = azurerm_resource_group.aks_wakaran.location
  resource_group_name = azurerm_resource_group.aks_wakaran.name

  tags = local.project_tags
}

resource "azurerm_network_security_rule" "allow_http_inbound" {
  name                        = "allow-http-inbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "0.0.0.0/0"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.aks.name
  resource_group_name         = azurerm_resource_group.aks_wakaran.name

  # NSGルールには tags 属性がありません
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id

  # アソシエーションには tags 属性がありません
}
