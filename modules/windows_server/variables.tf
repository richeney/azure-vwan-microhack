variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "Azure resource ID for the subnet."
}

variable "vmsize" {
  type        = string
  default     = "Standard_D2_v4"
  description = "Azure VM size. If using Windows Server 2022 then requires a Gen 2 capable size."
}

variable "admin_username" {
  type    = string
  default = "AzureAdmin"

}
variable "admin_password" {
  type    = string
  default = "Microhack2021"
}

variable "windows_server_version" {
  description = "Version of Windows Server. Can be either 2019 or 2022-preview."
  type        = string
  default     = "2022-preview"

  validation {
    condition     = contains(["2019", "2022-preview"], var.windows_server_version)
    error_message = "The os must be set to either 2019 or 2022-preview."
  }
}

variable "script" {
  type = string

  default = null

  validation {
    condition     = contains(["iis", "addc"], var.script)
    error_message = "The script type (pulled from osinfo). Must be set to either iis or addc."
  }
}
