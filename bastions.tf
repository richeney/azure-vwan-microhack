#######################################################################
## Create Bastion spoke-1
#######################################################################
resource "azurerm_public_ip" "bastion-spoke-1-pip" {
  name                = "bastion-spoke-1-pip"
  location            = var.location-spoke-1
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-spoke-1" {
  name                = "bastion-spoke-1"
  location            = var.location-spoke-1
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name

  ip_configuration {
    name                 = "bastion-spoke-1-configuration"
    subnet_id            = azurerm_subnet.bastion-spoke-1-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-spoke-1-pip.id
  }
}
#######################################################################
## Create Bastion spoke-2
#######################################################################
resource "azurerm_public_ip" "bastion-spoke-2-pip" {
  name                = "bastion-spoke-2-pip"
  location            = var.location-spoke-2
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-spoke-2" {
  name                = "bastion-spoke-2"
  location            = var.location-spoke-2
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name

  ip_configuration {
    name                 = "bastion-spoke-2-configuration"
    subnet_id            = azurerm_subnet.bastion-spoke-2-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-spoke-2-pip.id
  }
}
#######################################################################
## Create Bastion spoke-3
#######################################################################
resource "azurerm_public_ip" "bastion-spoke-3-pip" {
  name                = "bastion-spoke-3-pip"
  location            = var.location-spoke-3
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-spoke-3" {
  name                = "bastion-spoke-3"
  location            = var.location-spoke-3
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name

  ip_configuration {
    name                 = "bastion-spoke-3-configuration"
    subnet_id            = azurerm_subnet.bastion-spoke-3-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-spoke-3-pip.id
  }
}

#######################################################################
## Create Bastion spoke-4
#######################################################################
resource "azurerm_public_ip" "bastion-spoke-4-pip" {
  name                = "bastion-spoke-4-pip"
  location            = var.location-spoke-4
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-spoke-4" {
  name                = "bastion-spoke-4"
  location            = var.location-spoke-4
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name

  ip_configuration {
    name                 = "bastion-spoke-4-configuration"
    subnet_id            = azurerm_subnet.bastion-spoke-4-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-spoke-4-pip.id
  }
}

#######################################################################
## Create Bastion onprem
#######################################################################
resource "azurerm_public_ip" "bastion-onprem-pip" {
  name                = "bastion-onprem-pip"
  location            = var.location-onprem
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-onprem" {
  name                = "bastion-onprem"
  location            = var.location-onprem
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name

  ip_configuration {
    name                 = "bastion-onprem-configuration"
    subnet_id            = azurerm_subnet.bastion-onprem-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-onprem-pip.id
  }
}

#######################################################################
## Create Bastion Services
#######################################################################
resource "azurerm_public_ip" "bastion-services-pip" {
  name                = "bastion-services-pip"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-services" {
  name                = "bastion-services"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name

  ip_configuration {
    name                 = "bastion-services-configuration"
    subnet_id            = azurerm_subnet.bastion-services-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-services-pip.id
  }
}

#######################################################################
## Create Bastion NVA
#######################################################################
resource "azurerm_public_ip" "bastion-nva-pip" {
  name                = "bastion-services-nva"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion-nva" {
  name                = "bastion-nva"
  location            = var.location-spoke-services
  resource_group_name = azurerm_resource_group.vwan-microhack-spoke-rg.name

  ip_configuration {
    name                 = "bastion-nva-configuration"
    subnet_id            = azurerm_subnet.bastion-nva-subnet.id
    public_ip_address_id = azurerm_public_ip.bastion-nva-pip.id
  }
}
