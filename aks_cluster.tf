resource "azurerm_resource_group" "aks_resource_group" {
  name     = format("%s-aks",var.project_name)
  location = var.location
}

resource "azurerm_kubernetes_cluster" "project_aks_cluster" {
  name                       = format("%s%s",var.project_name,azurerm_resource_group.aks_resource_group.name)
  location                   = azurerm_resource_group.aks_resource_group.location
  resource_group_name        = azurerm_resource_group.aks_resource_group.name
  dns_prefix                 = azurerm_resource_group.aks_resource_group.name
  kubernetes_version         = var.kubernetes_version
  enable_pod_security_policy = var.enable_pod_security_policy
  tags                       = local.resource_tags

  default_node_pool {
    name                = local.project_name
    node_count          = var.agent_count
    max_count           = var.agent_max_count
    min_count           = var.agent_min_count
    vm_size             = var.agent_instance_size
    os_disk_type        = var.os_disk_type
    max_pods            = var.agent_max_pods
    os_disk_size_gb     = var.agent_os_disk_size_gb
    vnet_subnet_id      = data.azurerm_subnet.project_subnets.id
    type                = var.agent_pool_type
    enable_auto_scaling = var.enable_auto_scaling
  }

  #
  # Using the advanced networking configuration for integration into the existing vnet
  # See: https://docs.microsoft.com/en-us/azure/aks/configure-advanced-networking
  # 
  # This will allow for an internal azure loadbalancer in the private subnet:
  # https://docs.microsoft.com/en-us/azure/aks/internal-lb
  #
  network_profile {
    network_plugin = var.network_plugin
    network_policy = var.network_policy
    service_cidr   = var.service_cidr
    dns_service_ip = cidrhost(var.service_cidr, 10)
    docker_bridge_cidr = format(
      "%s/%s",
      cidrhost(var.docker_bridge_cidr, 5),
      element(split("/", var.docker_bridge_cidr), 1),
    )
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = local.ssh_key_data
    }
  }

  identity { 
    type = "SystemAssigned" 
  }

#   addon_profile {
  
#     http_application_routing {
#       enabled = false
#     }
#   }

#   role_based_access_control {
#     enabled = true

#     #
#     # Refer to: https://docs.microsoft.com/en-us/azure/aks/aad-integration
#     # for more info on the AzureAD auth integration
#     #
#     azure_active_directory {
#       client_app_id     = data.azuread_application.aks_aad_client_authid.application_id
#       server_app_id     = data.azuread_application.aks_aad_server_authid.application_id
#       server_app_secret = data.azurerm_key_vault_secret.aks_aad_server_secret.value
#       tenant_id         = data.azurerm_client_config.current.tenant_id
#     }
#   }

#   service_principal {
#     client_id     = data.azuread_service_principal.service_principal.application_id
#     client_secret = data.azurerm_key_vault_secret.project_admin_secret.value
#   }
# }
}

resource "local_file" "kube_conf" {
  content  = azurerm_kubernetes_cluster.project_aks_cluster.kube_config_raw
  filename = coalesce("${path.module}/kube_config", "${var.cache_dir}/kube_config")
}

# resource "local_file" "aks_ad_sp_credentials" {
#   filename = coalesce(
#     "${path.module}/aks_service_principal.json",
#     "${var.cache_dir}/aks_service_principal.json",
#   )

#   content = jsonencode(
#     {
#       "AZURE_CLIENT_ID"       = data.azuread_service_principal.service_principal.application_id
#       "AZURE_CLIENT_SECRET"   = data.azurerm_key_vault_secret.project_admin_secret.value
#       "AZURE_SUBSCRIPTION_ID" = data.azurerm_client_config.current.subscription_id
#       "AZURE_TENANT_ID"       = data.azurerm_client_config.current.tenant_id
#       "AZURE_RESOURCE_GROUP"  = format("%s-%s-dns", local.project_name, var.environment_name)
#     },
#   )
# }