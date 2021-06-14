variable "location" {
  default = ""
}

variable "machine_username" {
  default = ""
}

variable "kubernetes_version" {
  default = "1.19.7"
}

variable "admin_username" {}

variable "os_disk_type" {
  default = "Managed"
}

variable "agent_pool_type" {
  default = "VirtualMachineScaleSets"
}

variable "enable_auto_scaling" {
  default = false
}

variable "enable_pod_security_policy" {
  default = false
}

variable "log_resource_group_name" {
  default = "Logging"
}

variable "platform_name" {
  default = ""
}

# variable "log_analytics_workspace_name" {
#   default = "NonProdSaaSLogs"
# }

variable "project_name" {
}

variable "environment_name" {
  
}

variable "network_plugin" {
  default = ""
}

variable "virtual_network_name" {
  
}

variable "project_owner" {
}


variable "ssh_public_key" {
}

variable "keyvault_id" {
}

variable "agent_count" {
  default = "3"
}

variable "product_vnet_name" {
  default = ""
}

variable "vnet_resource_group" {
}

variable "agent_instance_size" {
  default = "Standard_E4s_v3"
}

variable "agent_os_disk_size_gb" {
  default = "128"
}

variable "agent_max_pods" {
  default = "48"
}

variable "agent_max_count" {
  default = 15
}

variable "agent_min_count" {
  default = 3
}

variable "service_cidr" {
  default = "0.0.0.0/0"
}

variable "docker_bridge_cidr" {
  default = "0.0.0.0/0"
}

variable "subnet_name" {
}

variable "additional_tags" {
  default = {}
}


variable "years" {
  default = 2
}

variable "end_date" {
  default = ""
}

variable "scope" {
  default = ""
}

variable "aks_aad_server_authid" {
  default = ""
}

variable "aks_aad_client_authid" {
  default = ""
}

variable "aks_aad_client_secret" {
}

variable "aks_aad_server_secret" {
}

variable "cluster_dns_prefix" {
  default = ""
}

variable "cache_dir" {
  default = ""
}



variable "aks_sp_display_name" {
  default = ""
}

variable "project_admin_secret" {
  default = ""
}

variable "network_policy" {
  default = null
}

variable "subscription_id" {}
variable "tenant_id" {}

variable "aks_resource_group" {}

variable "keyvault_resource_group" {
  default = ""
}