locals {
  project_name        = lower(var.project_name)
  environment_name    = lower(var.environment_name)
  ssh_key_data        = data.azurerm_key_vault_secret.ssh_public_key.value
  vnet_name           = format("%s", var.virtual_network_name)
  vnet_resource_group = var.vnet_resource_group
  resource_tags = merge(
    var.additional_tags,
    {
      "managed_by"   = "Terraform"
      "project_name" = var.project_name
      "owner"        = var.project_owner
    },
  )
  role_name  = format("%s-aks-role", lower(var.project_name))
  vault_name = format("%s-vault", lower(var.project_name))
}

#
# Lookups
#

data "azurerm_resource_group" "aks_resource_group" {
  name = var.aks_resource_group
}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
}

data "azurerm_virtual_network" "project_vnets" {
  name                = local.vnet_name
  resource_group_name = local.vnet_resource_group
}

data "azurerm_subnet" "project_subnets" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.project_vnets.name
  resource_group_name  = local.vnet_resource_group
}

data "azurerm_key_vault" "project_vault" {
  name                = var.keyvault_id
  resource_group_name = var.keyvault_resource_group
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name      = var.ssh_public_key
  key_vault_id = data.azurerm_key_vault.project_vault.id
}

data "azurerm_key_vault_secret" "project_admin_secret" {
  name      = var.project_admin_secret
  key_vault_id = data.azurerm_key_vault.project_vault.id
}

