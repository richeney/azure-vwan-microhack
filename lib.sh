##############################################################
# Library of functions
##############################################################

error()
{
  if [[ -n "$@" ]]
  then
    tput setaf 1
    echo "ERROR: $@" >&2
    tput sgr0
  fi

  exit 1
}

warning()
{
  if [[ -n "$@" ]]
  then
    tput setaf 3
    echo "WARNING: $@" >&2
    tput sgr0
  fi

  return
}

banner()
{
    tput setaf 6
    echo "+--------------------------------------------------------------------------------+"
    printf "| `tput bold` %-77s `tput rmso`|\n" "$@"
    echo "+--------------------------------------------------------------------------------+"
    tput sgr0

    return
}

delete_route_table()
{
  vhub=$1
  rt=$2

  rg=vwan-microhack-hub-rg
  vhubid=$(az network vhub show --name $vhub --resource-group $rg --query id --output tsv)
  [[ $? -ne 0 ]] && error "Virtual hub $vhub not found in resource group $rg"

  defaultrtid=$vhubid/hubRouteTables/defaultRouteTable

  rtid=$(az network vhub route-table show --name $rt --vhub-name $vhub --resource-group $rg --query id --output json 2>/dev/null)
  [[ $? -ne 0 ]] && { echo "Route table $rt not found in vhub $vhub. Continuing."; return; }

  echo "Switching any associations to the defaultRouteTable"
  associated=$(az network vhub route-table show --name $rt --vhub-name $vhub --resource-group $rg --output json --query associatedConnections --output tsv)

  if [[ -n "$associated" ]]
  then az network vhub connection update --ids $associated --associated-route-table $defaultrtid
  else echo "No connections are associated to $rt"
  fi

  echo

  echo "Modifying any connections propagating to $rt"
  propagated="$(az network vhub route-table show --name $rt --vhub-name $vhub --resource-group $rg --output json --query propagatingConnections --output tsv)"

  if [[ -n "$propagated" ]]
  then
    # JMESPATH query to gets a list of route table IDs that the connection is propagating to, removing the route table from the list
    # Updated the connection to use that list. If empty, default to defaultRouteTable

    query="routingConfiguration.propagatedRouteTables.ids[?!(ends_with(id,'RT-Shared-we'))].id"

    for vpngw_connection in $(grep "vpnConnections" <<< "$propagated")
    do
      echo "Changing vpn gateway connection ${vpngw_connection##*/}..."
      otherrtids=$(az network vpn-gateway connection show --ids $vpngw_connection --query $query --output tsv)
      az network vpn-gateway connection update --ids $vpngw_connection --propagated-route-tables ${otherrtids:=$defaultrtid}
    done

    for vnet_connection in $(grep "hubVirtualNetworkConnections" <<< "$propagated")
    do
      echo "Changing virtual network connection ${vnet_connection##*/}..."
      otherrtids=$(az network vhub connection show --ids $vnet_connection --query $query --output tsv)
      az network vhub connection update --ids $vnet_connection --propagated-route-tables ${otherrtids:=$defaultrtid}
    done
  else
    echo "No connections are propagating to $rt"
  fi

  # Check the two arrays are now empty
  query="max([length(associatedConnections),length(propagatingConnections)])"

  if [[ $(az network vhub route-table show --name $rt --vhub-name $vhub --resource-group $rg --query $query) -gt 0 ]]
  then
    az network vhub route-table show --name $rt --vhub-name $vhub --resource-group $rg --output jsonc
    error "Failed to clear out associatedConnections and/or propagatingConnections"
  else
    echo "The associatedConnections and propagatingConnections arrays are empty."
  fi

  echo "Deleting route table $rt from vhub $vhub"
  az network vhub route-table delete --name $rt --vhub-name microhack-we-hub --resource-group $rg
  if [[ $? -eq 0 ]]
  then echo "✔️"
  else error "Failed to delete route table $rt from vhub $vhub"
  fi

  return
}

## Commented out as everything has moved to CLI commands
## Retained for reference
##
## wait_for_succeeded()
## {
##   uri=$1
##   echo -n 'Waiting until properties.provisioningState == "Succeeded"...'
##   let n=0
##   until [[ $n -gt 60  ]]
##   do
##     _json=$(az rest --method get --uri $uri --output json)
##     _state=$(jq -r .properties.provisioningState <<<$_json)
##
##     case $_state in
##       Succeeded)
##         echo " successful!"
##         return
##         ;;
##       Failed)
##         echo "az rest --uri $uri"
##         jq . <<< $_json
##         error "Resource is in a failed state. Reset the vhub in the portal and rerun $(basename $0) once in a good state."
##         ;;
##       Provisioning)
##         echo -n "."
##         sleep 5
##         ;;
##       *)
##         echo $_state
##         sleep 5
##         ;;
##     esac
##
##     let n=n+1
##   done
##
##   echo "az rest --uri $uri"
##   jq . <<< $json
##   error "Waiting for resource success has timed out."
## }