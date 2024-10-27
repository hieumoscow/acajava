
# # https://learn.microsoft.com/en-us/azure/templates/microsoft.app/2023-11-02-preview/managedenvironments/javacomponents?pivots=deployment-language-terraform
# resource "azapi_resource" "SpringCloudConfig" {
#   type      = "Microsoft.App/managedEnvironments/javaComponents@2024-02-02-preview"
#   name      = "configserverhieu"
#   parent_id = azurerm_container_app_environment.env.id
#   body = jsonencode({
#     properties = {
#       componentType = "SpringCloudConfig"
#       # serviceBinds = [
#       #   {
#       #     name      = azurerm_container_app.app.name
#       #     serviceId = azurerm_container_app.app.id
#       #   },
#       # ]
#       configurations = [
#         {
#           propertyName  = "spring.cloud.config.server.git.uri"
#           value = "https://github.com/hieumoscow/acajv.git"
#         },
#         {
#           propertyName  = "spring.cloud.config.server.git.username"
#           value = "hieumoscow"
#         },
#         {
#           propertyName  = "spring.cloud.config.server.git.password"
#           value = "hieumoscow"
#         },
#       ]
#     }
#   })
# }


# resource "azapi_resource" "SpringCloudEureka" {
#   type      = "Microsoft.App/managedEnvironments/javaComponents@2024-02-02-preview"
#   name      = "eureka"
#   parent_id = azurerm_container_app_environment.env.id
#   body = jsonencode({
#     properties = {
#       componentType = "SpringCloudEureka"
#       # serviceBinds = [
#       #   {
#       #     name      = azurerm_container_app.app.name
#       #     serviceId = azurerm_container_app.app.id
#       #   },
#       # ]
#     }
#   })
# }

# resource "azapi_resource" "SpringBootAdmin" {
#   type      = "Microsoft.App/managedEnvironments/javaComponents@2024-02-02-preview"
#   name      = "admin"
#   parent_id = azurerm_container_app_environment.env.id
#   body = jsonencode({
#     properties = {
#       componentType = "SpringBootAdmin"
#       ingress       = {}
#       # serviceBinds = [
#       #   {
#       #     name      = azurerm_container_app.app.name
#       #     serviceId = azurerm_container_app.app.id
#       #   },
#       # ]
#     }
#   })
# }


# # Container App
# resource "azurerm_container_app" "app" {
#   name                         = var.name
#   container_app_environment_id = azurerm_container_app_environment.env.id
#   resource_group_name          = azurerm_resource_group.acarg.name
#   revision_mode                = "Single"

#   template {
#     container {
#       name   = "examplecontainerapp"
#       image  = "mcr.microsoft.com/k8se/quickstart:latest"
#       cpu    = 0.25
#       memory = "0.5Gi"
#     }
#   }

#   workload_profile_name = var.workload_profile_name
#     ingress {
#       external_enabled = true
#       allow_insecure_connections = false
#       target_port      = var.target_port
#       transport        = "auto"
#       traffic_weight {
#               latest_revision = true
#               percentage      = 100
#             }
#     }
# }

# # https://learn.microsoft.com/en-us/azure/templates/microsoft.app/containerapps?pivots=deployment-language-terraform
# resource "azapi_update_resource" "acaServiceBinds" {
#   type = "Microsoft.App/containerApps@2024-03-01"
#   name = azurerm_container_app.app.name
#   parent_id = azurerm_resource_group.acarg.id
#   body = jsonencode({
#     properties = {
#       template = {
#         serviceBinds = [
#           {
#             name      = azapi_resource.SpringCloudEureka.name
#             serviceId = azapi_resource.SpringCloudEureka.id
#           },
#           {
#             name      = azapi_resource.SpringCloudConfig.name
#             serviceId = azapi_resource.SpringCloudConfig.id
#           },
#           {
#             name      = azapi_resource.SpringBootAdmin.name
#             serviceId = azapi_resource.SpringBootAdmin.id
#           },
#         ]
#       }
#     }
#   })
# }
