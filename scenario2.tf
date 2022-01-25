resource "azurerm_vpn_site" "onprem" {
  name                = "onprem"
  resource_group_name = azurerm_resource_group.vwan-microhack-hub-rg.name
  location            = var.location-onprem
  virtual_wan_id      = azurerm_virtual_wan.microhack-vwan.id

  device_model  = "VNETGW"
  device_vendor = "Azure"

  link {
    name = "link1"
    bgp {
      asn             = azurerm_virtual_network_gateway.vnet-gw-onprem.bgp_settings[0].asn
      peering_address = azurerm_virtual_network_gateway.vnet-gw-onprem.bgp_settings[0].peering_addresses[0].default_addresses[0]
    }
    ip_address    = azurerm_virtual_network_gateway.vnet-gw-onprem.bgp_settings[0].peering_addresses[0].tunnel_ip_addresses[0]
    speed_in_mbps = 100
  }
}
