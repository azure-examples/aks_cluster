provider "azurerm" {
  version   = "~> 2.41"

  features {}
}

terraform {
  required_version = ">= 0.12"

  backend "azurerm" {
    resource_group_name  = "devops"
    storage_account_name = "devops1183c551c35f45fa8b"
    container_name       = "tfstate"
    key                  = "aks"
  }
}

resource "azurerm_resource_group" "default" {
  name     = "aks-central-us-${terraform.workspace}"
  location = "Central US"
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "aks-central-us-${terraform.workspace}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "salte-${terraform.workspace}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = terraform.workspace
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.default.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.default.kube_config_raw
}
