#!/bin/bash
##########################################################
# prep-for-scenario-5.sh
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
    echo "The $connection connection not found. Skipping."
  fi
done

####################################################################

banner "Removing route table RT-Shared-we from vhub microhack-we-hub"

delete_route_table microhack-we-hub RT-Shared-we

####################################################################

banner "Removing route table RT-Shared-useast from vhub microhack-useast-hub"

delete_route_table microhack-useast-hub RT-Shared-useast

####################################################################

banner "Peering nva-vnet to vhub and to spokes 1 and 2"

echo "Connecting virtual network nva-vnet to vhub microhack-we-hub"
nvavnetid=$(az network vnet show --name nva-vnet --resource-group vwan-microhack-spoke-rg --query "id" --output tsv)
az network vhub connection create --name nva-we --vhub-name microhack-we-hub --remote-vnet $nvavnetid --resource-group vwan-microhack-hub-rg --no-wait --output jsonc
echo "Submitted with --no-wait. Check status in the portal before using."

echo

echo "Peering spoke-1-vnet to nva-vnet"
az network vnet peering create --name spoke1-to-nva --resource-group vwan-microhack-spoke-rg --vnet-name spoke-1-vnet --remote-vnet nva-vnet --allow-vnet-access --allow-forwarded-traffic --output jsonc
echo "Peering nva-vnet back to spoke-1-vnet"
az network vnet peering create --name nva-to-spoke1 --resource-group vwan-microhack-spoke-rg --vnet-name nva-vnet --remote-vnet spoke-1-vnet --allow-vnet-access --allow-forwarded-traffic --output jsonc

echo

echo "Peering spoke-2-vnet to nva-vnet"
az network vnet peering create --name spoke2-to-nva --resource-group vwan-microhack-spoke-rg --vnet-name spoke-2-vnet --remote-vnet nva-vnet --allow-vnet-access --allow-forwarded-traffic --output jsonc
echo "Peering nva-vnet back to spoke-2-vnet"
az network vnet peering create --name nva-to-spoke2 --resource-group vwan-microhack-spoke-rg --vnet-name nva-vnet --remote-vnet spoke-2-vnet --allow-vnet-access --allow-forwarded-traffic --output jsonc

banner "Complete"