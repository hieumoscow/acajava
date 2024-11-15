resource "azapi_resource" "SpringEurekaServer" {
  type      = "Microsoft.App/managedEnvironments/javaComponents@2024-02-02-preview"
  name      = "spring-eureka-server"
  parent_id = azurerm_container_app_environment.env.id
  body = jsonencode({
    properties = {
      componentType = "SpringCloudEureka"
      configurations = [
        for config in var.eureka_server_configurations : {
          propertyName = config.name
          value        = config.value
        }
      ]
    }
  })
}

resource "azapi_resource" "SpringBootAdmin" {
  type      = "Microsoft.App/managedEnvironments/javaComponents@2024-02-02-preview"
  name      = "spring-boot-admin"
  parent_id = azurerm_container_app_environment.env.id
  body = jsonencode({
    properties = {
      componentType = "SpringBootAdmin"
      ingress       = {}
    }
  })
}

resource "azapi_resource" "SpringCloudConfig" {
  type      = "Microsoft.App/managedEnvironments/javaComponents@2024-02-02-preview"
  name      = "spring-config-server"
  parent_id = azurerm_container_app_environment.env.id
  body = jsonencode({
    properties = {
      componentType = "SpringCloudConfig"
      configurations = [
        for config in var.spring_config_configurations : {
          propertyName = config.name
          value        = config.value
        }
      ]
    }
  })
}

resource "azapi_resource" "my-eureka-client" {
  type      = "Microsoft.App/containerApps@2024-03-01"
  name      = "my-eureka-client"
  parent_id = azurerm_resource_group.acarg.id
  location  = azurerm_resource_group.acarg.location

  body = jsonencode({
    properties = {
      environmentId = azurerm_container_app_environment.env.id
      configuration = {
        activeRevisionsMode = "Single"
        ingress = {
          external      = true
          allowInsecure = false
          targetPort    = 8080
          transport     = "auto"
          traffic = [
            {
              latestRevision = true
              weight         = 100
            }
          ]
        }
      }
      template = {
        containers = [
          {
            name  = "eureka-client"
            image = "mcr.microsoft.com/javacomponents/samples/sample-service-eureka-client:latest"
            resources = {
              cpu    = 1
              memory = "0.5Gi"
            }
          }
        ]
        scale = {
          minReplicas = 1
          maxReplicas = 1
        }
        serviceBinds = [
          {
            name      = azapi_resource.SpringEurekaServer.name
            serviceId = azapi_resource.SpringEurekaServer.id
          },
          {
            name      = azapi_resource.SpringBootAdmin.name
            serviceId = azapi_resource.SpringBootAdmin.id
          },
          {
            name      = azapi_resource.SpringCloudConfig.name
            serviceId = azapi_resource.SpringCloudConfig.id
          },
        ]
      }
      workloadProfileName = var.workload_profile_name
    }
  })

  schema_validation_enabled = false
  response_export_values    = ["*"]
}


resource "azapi_resource" "my-admin-client" {
  type      = "Microsoft.App/containerApps@2024-03-01"
  name      = "my-admin-client"
  parent_id = azurerm_resource_group.acarg.id
  location  = azurerm_resource_group.acarg.location

  body = jsonencode({
    properties = {
      environmentId = azurerm_container_app_environment.env.id
      configuration = {
        activeRevisionsMode = "Single"
        ingress = {
          external      = true
          allowInsecure = false
          targetPort    = 8080
          transport     = "auto"
          traffic = [
            {
              latestRevision = true
              weight         = 100
            }
          ]
        }
      }
      template = {
        containers = [
          {
            name  = "my-admin-client"
            image = "mcr.microsoft.com/javacomponents/samples/sample-admin-for-spring-client:latest"
            resources = {
              cpu    = 0.5
              memory = "0.5Gi"
            }
          }
        ]
        scale = {
          minReplicas = 1
          maxReplicas = 1
        }
        serviceBinds = [
          {
            name      = azapi_resource.SpringEurekaServer.name
            serviceId = azapi_resource.SpringEurekaServer.id
          },
          {
            name      = azapi_resource.SpringBootAdmin.name
            serviceId = azapi_resource.SpringBootAdmin.id
          },
          {
            name      = azapi_resource.SpringCloudConfig.name
            serviceId = azapi_resource.SpringCloudConfig.id
          },
        ]
      }
      workloadProfileName = var.workload_profile_name
    }
  })

  schema_validation_enabled = false
  response_export_values    = ["*"]
}
