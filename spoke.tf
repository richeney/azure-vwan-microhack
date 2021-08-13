#######################################################################
## Create Virtual Network - Spoke 1
#######################################################################

resource "azurerm_virtual_network" "spoke-1-vnet" {
  name                = "spoke-1-vnet"
  location            = var.location-spoke-1
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.1.0/24"]

  tags = {
    environment = "spoke-1"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}

#######################################################################
## Create Subnets - Spoke 1
#######################################################################

resource "azurerm_subnet" "spoke-1-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-1-vnet.name
  address_prefixes     = ["172.16.1.0/25"]
}

resource "azurerm_subnet" "bastion-spoke-1-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-1-vnet.name
  address_prefixes     = ["172.16.1.128/27"]
}

#######################################################################
## Create Virtual Network - Spoke 2
#######################################################################

resource "azurerm_virtual_network" "spoke-2-vnet" {
  name                = "spoke-2-vnet"
  location            = var.location-spoke-2
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.2.0/24"]

  tags = {
    environment = "spoke-2"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}

#######################################################################
## Create Subnets - Spoke 2
#######################################################################
resource "azurerm_subnet" "spoke-2-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-2-vnet.name
  address_prefixes     = ["172.16.2.0/25"]
}

resource "azurerm_subnet" "bastion-spoke-2-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-2-vnet.name
  address_prefixes     = ["172.16.2.128/27"]
}

#######################################################################
## Create Virtual Network - Spoke 3
#######################################################################
resource "azurerm_virtual_network" "spoke-3-vnet" {
  name                = "spoke-3-vnet"
  location            = var.location-spoke-3
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.3.0/24"]

  tags = {
    environment = "spoke-3"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}

#######################################################################
## Create Subnets - Spoke 3
#######################################################################
resource "azurerm_subnet" "spoke-3-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-3-vnet.name
  address_prefixes     = ["172.16.3.0/25"]
}

resource "azurerm_subnet" "bastion-spoke-3-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-3-vnet.name
  address_prefixes     = ["172.16.3.128/27"]
}

#######################################################################
## Create Virtual Network - Spoke 4
#######################################################################

resource "azurerm_virtual_network" "spoke-4-vnet" {
  name                = "spoke-4-vnet"
  location            = var.location-spoke-4
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.4.0/24"]

  tags = {
    environment = "spoke-4"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}

#######################################################################
## Create Subnets - Spoke 4
#######################################################################

resource "azurerm_subnet" "spoke-4-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-4-vnet.name
  address_prefixes     = ["172.16.4.0/25"]
}

resource "azurerm_subnet" "bastion-spoke-4-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.spoke-4-vnet.name
  address_prefixes     = ["172.16.4.128/27"]
}

#######################################################################
## Create Virtual Network - Onprem
#######################################################################

resource "azurerm_virtual_network" "onprem-vnet" {
  name                = "onprem-vnet"
  location            = var.location-onprem
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["10.0.1.0/24", "10.0.2.0/24"]

  tags = {
    environment = "onprem"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}

#######################################################################
## Create Subnets - onprem
#######################################################################
resource "azurerm_subnet" "onprem-vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem-vnet.name
  address_prefixes     = ["10.0.1.0/25"]
}

resource "azurerm_subnet" "bastion-onprem-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem-vnet.name
  address_prefixes     = ["10.0.1.128/27"]
}

resource "azurerm_subnet" "onprem-gateway-subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.onprem-vnet.name
  address_prefixes     = ["10.0.1.160/27"]
}

#######################################################################
## Create Virtual Network - Services
#######################################################################
resource "azurerm_virtual_network" "services-vnet" {
  name                = "services-vnet"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.10.0/24"]

  tags = {
    environment = "services"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}

#######################################################################
## Create Subnets - Services
#######################################################################

resource "azurerm_subnet" "services-vm-1-subnet" {
  name                 = "servicesSubnet-1"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.services-vnet.name
  address_prefixes     = ["172.16.10.0/25"]
}

resource "azurerm_subnet" "services-vm-2-subnet" {
  name                 = "servicesSubnet-2"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.services-vnet.name
  address_prefixes     = ["172.16.10.128/27"]
}

resource "azurerm_subnet" "bastion-services-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.services-vnet.name
  address_prefixes     = ["172.16.10.160/27"]
}

#######################################################################
## Create Virtual Network - NVA
#######################################################################
resource "azurerm_virtual_network" "nva-vnet" {
  name                = "nva-vnet"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  address_space       = ["172.16.20.0/24"]

  tags = {
    environment = "nva"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}
#######################################################################
## Create Subnets - NVA
#######################################################################

resource "azurerm_subnet" "nva-subnet-1" {
  name                 = "nva-subnet-1"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.nva-vnet.name
  address_prefixes     = ["172.16.20.0/26"]
}

resource "azurerm_subnet" "nva-subnet-2" {
  name                 = "nva-subnet-2"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.nva-vnet.name
  address_prefixes     = ["172.16.20.64/26"]
}

resource "azurerm_subnet" "bastion-nva-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  virtual_network_name = azurerm_virtual_network.nva-vnet.name
  address_prefixes     = ["172.16.20.160/27"]
}

#######################################################################
## Create Network Interface - Spoke 1
#######################################################################
/*resource "azurerm_network_interface" "spoke-1-nic" {
  name                 = "spoke-1-nic"
  location             = var.location-spoke-1
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "spoke-1-ipconfig"
    subnet_id                     = azurerm_subnet.spoke-1-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "spoke-1"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}

#######################################################################
## Create Network Interface - Spoke 2
#######################################################################

resource "azurerm_network_interface" "spoke-2-nic" {
  name                 = "spoke-2-nic"
  location             = var.location-spoke-2
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "spoke-2-ipconfig"
    subnet_id                     = azurerm_subnet.spoke-2-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "spoke-1"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}
#######################################################################
## Create Network Interface - Spoke 3
#######################################################################

resource "azurerm_network_interface" "spoke-3-nic" {
  name                 = "spoke-3-nic"
  location             = var.location-spoke-3
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "spoke-3-ipconfig"
    subnet_id                     = azurerm_subnet.spoke-3-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "spoke-3"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}
#######################################################################
## Create Network Interface - Spoke 4
#######################################################################

resource "azurerm_network_interface" "spoke-4-nic" {
  name                 = "spoke-4-nic"
  location             = var.location-spoke-4
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "spoke-4"
    subnet_id                     = azurerm_subnet.spoke-4-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "spoke-4"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}
#######################################################################
## Create Network Interface - Spoke onprem
#######################################################################

resource "azurerm_network_interface" "onprem-nic" {
  name                 = "onprem-nic"
  location             = var.location-onprem
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "onprem-ipconfig"
    subnet_id                     = azurerm_subnet.onprem-vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "onprem"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}

#######################################################################
## Create Network Interface - ADDC
#######################################################################

resource "azurerm_network_interface" "spoke-addc-1-nic" {
  name                 = "spoke-addc-1-nic"
  location             = var.location-spoke-services
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "addc-1-ipconfig"
    subnet_id                     = azurerm_subnet.services-vm-1-subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "services"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}

*/

#######################################################################
## Using marketplace offering, so agree terms. Equivalent to:
##  az term accept \
##    --product "microsoftserveroperatingsystems-previews" \
##    --publisher "microsoftwindowsserver" \
##    --plan "windows-server-2022-azure-edition-preview"
#######################################################################

// resource "azurerm_marketplace_agreement" "windows_server_2022_preview" {
//   publisher = "microsoftwindowsserver"
//   offer     = "microsoftserveroperatingsystems-previews"
//   plan      = "windows-server-2022-azure-edition-preview"
// }

#######################################################################
## Create Virtual Machine spoke-1
#######################################################################

module "spoke-1" {
  source     = "./modules/windows_server"
  depends_on = [azurerm_marketplace_agreement.windows_server_2022_preview]

  name                = "spoke-1"
  location            = var.location-spoke-1
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  subnet_id           = azurerm_subnet.spoke-1-vm-subnet.id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  script              = "iis"
}

#######################################################################
## Create Virtual Machine spoke-2
#######################################################################

module "spoke-2" {
  source     = "./modules/windows_server"
  depends_on = [azurerm_marketplace_agreement.windows_server_2022_preview]

  name                = "spoke-2"
  location            = var.location-spoke-2
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  subnet_id           = azurerm_subnet.spoke-2-vm-subnet.id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  script              = "iis"
}

#######################################################################
## Create Virtual Machine spoke-3
#######################################################################

module "spoke-3" {
  source     = "./modules/windows_server"
  depends_on = [azurerm_marketplace_agreement.windows_server_2022_preview]

  name                = "spoke-3"
  location            = var.location-spoke-3
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  subnet_id           = azurerm_subnet.spoke-3-vm-subnet.id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  script              = "iis"
}


#######################################################################
## Create Virtual Machine spoke-4
#######################################################################

module "spoke-4" {
  source     = "./modules/windows_server"
  depends_on = [azurerm_marketplace_agreement.windows_server_2022_preview]

  name                = "spoke-4"
  location            = var.location-spoke-4
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  subnet_id           = azurerm_subnet.spoke-4-vm-subnet.id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  script              = "iis"
}

#######################################################################
## Create Virtual Machine onprem
#######################################################################

module "onprem" {
  source     = "./modules/windows_server"
  depends_on = [azurerm_marketplace_agreement.windows_server_2022_preview]

  name                = "onprem"
  location            = var.location-onprem
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  subnet_id           = azurerm_subnet.onprem-vm-subnet.id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  script              = "iis"
}



#######################################################################
## Create Virtual Machine spoke-addc
#######################################################################

module "spoke-addc" {
  source     = "./modules/windows_server"
  depends_on = [azurerm_marketplace_agreement.windows_server_2022_preview]

  name                = "spoke-addc"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  subnet_id           = azurerm_subnet.services-vm-1-subnet.id
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  script              = "addc"
}

#######################################################################
## Create Network Interface - nva-iptables-vm
#######################################################################
resource "azurerm_public_ip" "nva-iptables-vm-pub-ip" {
  name                = "nva-iptables-vm-pub-ip"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  tags = {
    environment = "nva"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}
resource "azurerm_network_security_group" "nva-iptables-vm-nsg" {
  name                = "nva-iptables-vm-nsg"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name


  security_rule {
    name                       = "http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 210
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "icmp"
    priority                   = 220
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "nva"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}
resource "azurerm_network_interface" "nva-iptables-vm-nic-1" {
  name                 = "nva-iptables-vm-nic-1"
  location             = var.location-spoke-services
  resource_group_name  = azurerm_resource_group.vwan-microhack-spoke-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "nva-1-ipconfig"
    subnet_id                     = azurerm_subnet.nva-subnet-1.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.16.20.4"
    public_ip_address_id          = azurerm_public_ip.nva-iptables-vm-pub-ip.id
  }

  tags = {
    environment = "nva"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}
resource "azurerm_subnet_network_security_group_association" "nva-iptables-vm-nsg-ass" {
  subnet_id                 = azurerm_subnet.nva-subnet-1.id
  network_security_group_id = azurerm_network_security_group.nva-iptables-vm-nsg.id
}

#######################################################################
## Create Virtual Machine - NVA
#######################################################################
resource "azurerm_linux_virtual_machine" "nva-iptables-vm" {
  name                            = "nva-iptables-vm"
  location                        = var.location-spoke-services
  resource_group_name             = azurerm_resource_group.vwan-microhack-spoke-rg.name
  network_interface_ids           = [azurerm_network_interface.nva-iptables-vm-nic-1.id]
  size                            = "Standard_D2_v4"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "nva-iptables-vm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  tags = {
    environment = "nva"
    deployment  = "terraform"
    microhack   = "vwan"
  }
}

##########################################################
## Enable routing on nva-iptables-vm
##########################################################

resource "azurerm_virtual_machine_extension" "enable-routing-nva-iptables-vm" {

  name                 = "enable-routing-nva-iptables-vm"
  virtual_machine_id   = azurerm_linux_virtual_machine.nva-iptables-vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
        "script": "c3VkbyBjaG1vZCA3NzcgL2V0Yy9zeXNjdGwuY29uZgplY2hvICJuZXQuaXB2NC5pcF9mb3J3YXJkID0gMSIgPiAvZXRjL3N5c2N0bC5jb25mCnN1ZG8gc3lzY3RsIC1wIC9ldGMvc3lzY3RsLmNvbmYKc3VkbyBpcHRhYmxlcyAtdCBuYXQgLUEgUE9TVFJPVVRJTkcgLWQgMTAuMC4wLjAvOCAtaiBBQ0NFUFQKc3VkbyBpcHRhYmxlcyAtdCBuYXQgLUEgUE9TVFJPVVRJTkcgLWQgMTcyLjE2LjAuMC8xMiAtaiBBQ0NFUFQKc3VkbyBpcHRhYmxlcyAtdCBuYXQgLUEgUE9TVFJPVVRJTkcgLWQgMTkyLjE2OC4wLjAvMTYgLWogQUNDRVBUCnN1ZG8gaXB0YWJsZXMgLXQgbmF0IC1BIFBPU1RST1VUSU5HIC1vIGV0aDAgLWogTUFTUVVFUkFERQ=="
    }
SETTINGS
}
