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
    name = var.workload_profile_name
    workload_profile_type = var.workload_profile_type
    maximum_count = 1
    minimum_count = 1
  }
}

resource "azapi_resource" "SpringCloudConfig" {
  type = "Microsoft.App/managedEnvironments/javaComponents@2024-02-02-preview"
  name = "configserver"
  parent_id = azurerm_container_app_environment.env.id
  body = jsonencode({
    properties = {
      componentType = "SpringCloudConfig"
    }
  })
}


resource "azapi_resource" "SpringCloudEureka" {
  type = "Microsoft.App/managedEnvironments/javaComponents@2024-02-02-preview"
  name = "eureka"
  parent_id = azurerm_container_app_environment.env.id
  body = jsonencode({
    properties = {
      componentType = "SpringCloudEureka"
    }
  })
}

resource "azapi_resource" "SpringBootAdmin" {
  type = "Microsoft.App/managedEnvironments/javaComponents@2024-02-02-preview"
  name = "admin"
  parent_id = azurerm_container_app_environment.env.id
  body = jsonencode({
    properties = {
      componentType = "SpringBootAdmin"
      ingress = {}
    }
  })
}


# Container App
resource "azurerm_container_app" "app" {
  name                         = var.name
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.acarg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/k8se/quickstart:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }

  workload_profile_name = var.workload_profile_name
#   ingress {
#     external_enabled = var.is_public
#     target_port      = var.target_port
#     transport        = "auto"
#   }
}


