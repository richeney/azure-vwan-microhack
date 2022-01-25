resource "azurerm_virtual_hub_connection" "spoke-1-we" {
  name                      = "spoke-1-we"
  virtual_hub_id            = azurerm_virtual_hub.microhack-we-hub.id
  remote_virtual_network_id = azurerm_virtual_network.spoke-1-vnet.id
  internet_security_enabled = true
}

resource "azurerm_virtual_hub_connection" "spoke-2-we" {
  name                      = "spoke-2-we"
  // depends_on                = [azurerm_virtual_hub_connection.spoke-1-we]
  virtual_hub_id            = azurerm_virtual_hub.microhack-we-hub.id
  remote_virtual_network_id = azurerm_virtual_network.spoke-2-vnet.id
  internet_security_enabled = true
}
