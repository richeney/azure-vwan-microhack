#!/bin/bash
##########################################################
# clean-up-after-scenario-4.sh
##########################################################

# Source our bash library
. ./lib.sh

vwan=microhack-vwan
rg=vwan-microhack-hub-rg
vwanid=$(az network vwan show --name $vwan -g$rg --query id --output tsv)

####################################################################

banner "Removing connections spoke-1-we and spoke-2-we from vhub microhack-we-hub"

for connection in spoke-1-we spoke-2-we
do
  if az network vhub connection show --name $connection --resource-group vwan-microhack-hub-rg --vhub-name microhack-we-hub --output none 2>/dev/null
  then
    printf "%s " "Removing connection $connection..."
    az network vhub connection delete --name $connection --vhub-name microhack-we-hub --resource-group vwan-microhack-hub-rg --yes --output none
    [[ $? -eq 0 ]] && echo "✔️" || error "Failed to delete connection $connection from vhub microhack-we-hub"
  else
    echo "The $connection connection has already been removed."
  fi
done

####################################################################

banner "Removing route table RT-Shared-we from vhub microhack-we-hub"

delete_route_table microhack-we-hub RT-Shared-we

####################################################################

banner "Removing route table RT-Shared-useast from vhub microhack-useast-hub"

delete_route_table microhack-useast-hub RT-Shared-useast

####################################################################

banner "Final cleanup steps"

echo "Disconnecting branch"
az network vpn-gateway connection delete --gateway-name microhack-we-hub-vpngw --name onprem -g vwan-microhack-hub-rg
az network vpn-site delete --name onprem -g vwan-microhack-hub-rg

echo "Deleting VPN gateway"
az network vpn-gateway delete --name microhack-we-hub-vpngw -g vwan-microhack-hub-rg

echo "Deleting virtual hubs"
vhubids=$(az network vhub list --resource-group vwan-microhack-hub-rg --query [].id --output tsv)
[[ -n "$vhubids" ]] && az network vhub delete --ids $vhubids

echo "Deleting resource groups"
az group delete --resource-group vwan-microhack-hub-rg --yes
az group delete --resource-group vwan-microhack-spoke-rg --yes

banner "Complete"
