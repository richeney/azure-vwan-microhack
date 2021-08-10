data "external" "github" {
  // Returns {"raw_uri_path": "https://raw.githubusercontent.com/mddazure/azure-vwan-microhack/master/powershell"} or current
  // Used in the custom script extension
  program = ["bash", "${path.module}/raw_uri_path.sh"]
}

locals {
  raw_uri_path = data.external.github.result["raw_uri_path"]

  osinfo = {
    "2019" = {
      offer     = "WindowsServer"
      publisher = "MicrosoftWindowsServer"
      sku       = "2019-Datacenter"
      preview   = false
      script = {
        iis = [
          "${local.raw_uri_path}/powershell/ie.ps1"
        ]
        addc = [
          "${local.raw_uri_path}/powershell/addc.ps1"
        ]
      }
    }
    "2022-preview" = {
      publisher = "microsoftwindowsserver"
      offer     = "microsoftserveroperatingsystems-previews"
      sku       = "windows-server-2022-azure-edition-preview"
      preview   = true
      script = {
        iis = [
          "${local.raw_uri_path}/powershell/edge.ps1",
          "${local.raw_uri_path}/powershell/msedge.admx",
          "${local.raw_uri_path}/powershell/msedge.adml"
        ]
        addc = [
          "${local.raw_uri_path}/powershell/addc.ps1"
        ]
      }
    }
  }

  os = local.osinfo[var.windows_server_version]

  tags = {
    environment = var.name
    deployment  = "terraform"
    microhack   = "vwan"
  }
}

resource "azurerm_network_interface" "vm" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  ip_configuration {
    name                          = "${var.name}-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  enable_ip_forwarding = false
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "${var.name}-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  network_interface_ids = [azurerm_network_interface.vm.id]
  size                  = var.vmsize
  computer_name         = "${var.name}-vm"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  provision_vm_agent    = true

  os_disk {
    name                 = "${var.name}-os"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  dynamic "plan" {
    for_each = toset(local.os.preview ? [local.os] : [])
    content {
      name      = plan.value.sku
      publisher = plan.value.publisher
      product   = plan.value.offer
    }
  }

  source_image_reference {
    publisher = local.os.publisher
    offer     = local.os.offer
    sku       = local.os.sku
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "vm" {
  name                 = "install-${var.script}-on-${var.name}"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  // The coalesce function returns the first, i.e. the master script if more than one file is in the fileUris.
  // Basename then strips the directory
  // (The ellipsis on the array converts a list of strings to a set of comma delimited arguments.)

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File ${basename(coalesce(local.os.script[var.script]...))}"
    fileUris         = local.os.script[var.script]
  })
}
