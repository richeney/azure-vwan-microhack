az extension add --name virtual-wan

echo "# VNETGW: Get parameters from onprem vnet gateway"
vnetgwtunnelip0=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[0].tunnelIpAddresses[0]" --output tsv)
vnetgwtunnelip1=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[1].tunnelIpAddresses[0]" --output tsv)
echo "VNET GW Tunnel addresses:" $vnetgwtunnelip0 $vnetgwtunnelip1
vnetgwbgpip0=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[0].defaultBgpIpAddresses[0]" --output tsv)
vnetgwbgpip1=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.bgpPeeringAddresses[1].defaultBgpIpAddresses[0]" --output tsv)
echo "VNET GW BGP addresses:" $vnetgwbgpip0 $vnetgwbgpip1
vnetgwasn=$(az network vnet-gateway show -n vnet-gw-onprem -g vwan-microhack-spoke-rg --query "bgpSettings.asn" --output tsv)
echo "VNET GW BGP ASN:" $vnetgwasn
sharedkey="m1cr0hack"

echo "# VWAN: Create remote site"
az network vpn-site create --ip-address $vnetgwtunnelip0 --name onprem -g vwan-microhack-hub-rg --asn $vnetgwasn --bgp-peering-address $vnetgwbgpip0 --virtual-wan microhack-vwan --location northeurope --device-model VNETGW --device-vendor Azure --link-speed 100

echo "# VWAN: Create connection - remote site to hub gw"
az network vpn-gateway connection create --gateway-name microhack-we-hub-vpngw --name onprem --remote-vpn-site onprem -g vwan-microhack-hub-rg --shared-key $sharedkey --enable-bgp true --no-wait

echo "# VWAN: Get parameters from VWAN Hub GW"
hubgwtunneladdress0=$(az network vpn-gateway show --name microhack-we-hub-vpngw  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].tunnelIpAddresses[0]" --output tsv)
hubgwtunneladdress1=$(az network vpn-gateway show --name microhack-we-hub-vpngw  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance1'].tunnelIpAddresses[0]" --output tsv)
echo "Hub GW Tunnel addresses:" $hubgwtunneladdress0  $hubgwtunneladdress1
hubgwbgpaddress0=$(az network vpn-gateway show --name microhack-we-hub-vpngw  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance0'].defaultBgpIpAddresses" --output tsv)
hubgwbgpaddress1=$(az network vpn-gateway show --name microhack-we-hub-vpngw  -g vwan-microhack-hub-rg --query "bgpSettings.bgpPeeringAddresses[?ipconfigurationId == 'Instance1'].defaultBgpIpAddresses" --output tsv)
echo "Hub GW BGP addresses:" $hubgwbgpaddress0 $hubgwbgpaddress1
hubgwasn=$(az network vpn-gateway show --name microhack-we-hub-vpngw  -g vwan-microhack-hub-rg --query "bgpSettings.asn" --output tsv)
echo "Hub GW BGP ASN:" $hubgwasn
hubgwkey=$(az network vpn-gateway connection show --gateway-name microhack-we-hub-vpngw --name onprem -g vwan-microhack-hub-rg --query "sharedKey" --output tsv)

echo "# create local network gateway"
az network local-gateway create -g vwan-microhack-spoke-rg -n lng --gateway-ip-address $hubgwtunneladdress0 --location westeurope --asn $hubgwasn --bgp-peering-address $hubgwbgpaddress0

echo "# VNET GW: connect from vnet gw to local network gateway"
az network vpn-connection create -n to-we-hub --vnet-gateway1 vnet-gw-onprem -g vwan-microhack-spoke-rg --local-gateway2 lng -l northeurope --shared-key $sharedkey --enable-bgp
