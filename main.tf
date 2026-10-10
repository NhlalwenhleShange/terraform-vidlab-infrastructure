terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  default = "southafricanorth"
}

variable "prefix" {
  default = "vidlab02"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Production"
    Project     = "VidLab"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-prod"
  location = var.location
  tags     = var.tags
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acrprod01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = var.tags
}

resource "azurerm_log_analytics_workspace" "logs" {
  name                = "log-${var.prefix}-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_container_app_environment" "env" {
  name                       = "cae-${var.prefix}-prod"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
  tags                       = var.tags
}

resource "azurerm_storage_account" "st" {
  name                     = "${var.prefix}stprod01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_storage_container" "videos" {
  name                  = "videos"
  storage_account_name  = azurerm_storage_account.st.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "frames" {
  name                  = "frames"
  storage_account_name  = azurerm_storage_account.st.name
  container_access_type = "private"
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}
output "resource_group" {
  value = azurerm_resource_group.rg.name
}
output "storage_account" {
  value = azurerm_storage_account.st.name
}
output "container_app_env" {
  value = azurerm_container_app_environment.env.name
}