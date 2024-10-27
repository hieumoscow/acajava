# main.tf
# Resource Group
resource "azurerm_resource_group" "acarg" {
  name     = var.resource_group_name
  location = var.location
}


# Container Apps Environment
resource "azurerm_container_app_environment" "env" {
  name                       = "${var.name}-env"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.acarg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  #   infrastructure_subnet_id   = azurerm_subnet.aca_subnet.id
  #   internal_load_balancer_enabled = true

  workload_profile {
    name                  = var.workload_profile_name
    workload_profile_type = var.workload_profile_type
    maximum_count         = 1
    minimum_count         = 1
  }
}
