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

}

resource "local_file" "kube_conf" {
  content  = azurerm_kubernetes_cluster.project_aks_cluster.kube_config_raw
  filename = coalesce("${path.module}/kube_config", "${var.cache_dir}/kube_config")
}

