resource "azapi_resource" "SampleEureka" {
  type      = "Microsoft.App/managedEnvironments/javaComponents@2024-02-02-preview"
  name      = "sampleeureka"
  parent_id = azurerm_container_app_environment.env.id
  body = jsonencode({
    properties = {
      componentType = "SpringCloudEureka"
      configurations = [
        {
          propertyName = "eureka.server.renewal-percent-threshold"
          value        = "0.85"
        },
        {
          propertyName = "eureka.server.eviction-interval-timer-in-ms"
          value        = "10000"
        }
      ]
    }
  })
}

resource "azapi_resource" "SampleAdmin" {
  type      = "Microsoft.App/managedEnvironments/javaComponents@2024-02-02-preview"
  name      = "sampleadmin"
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
  name      = "configserverhieu"
  parent_id = azurerm_container_app_environment.env.id
  body = jsonencode({
    properties = {
      componentType = "SpringCloudConfig"
      # serviceBinds = [
      #   {
      #     name      = azurerm_container_app.app.name
      #     serviceId = azurerm_container_app.app.id
      #   },
      # ]
      configurations = [
        {
          propertyName = "spring.cloud.config.server.git.uri"
          value        = "https://github.com/hieumoscow/acajv.git"
        },
        {
          propertyName = "spring.cloud.config.server.git.username"
          value        = "test"
        },
        {
          propertyName = "spring.cloud.config.server.git.password"
          value        = "test"
        },
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
            name  = "sample-service-eureka-client"
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
            name      = azapi_resource.SampleEureka.name
            serviceId = azapi_resource.SampleEureka.id
          },
          {
            name      = azapi_resource.SampleAdmin.name
            serviceId = azapi_resource.SampleAdmin.id
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


resource "azapi_resource" "sample-service-eureka-client" {
  type      = "Microsoft.App/containerApps@2024-03-01"
  name      = "sample-service-eureka-client"
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
            name  = "sample-service-eureka-client"
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
            name      = azapi_resource.SampleEureka.name
            serviceId = azapi_resource.SampleEureka.id
          },
          {
            name      = azapi_resource.SampleAdmin.name
            serviceId = azapi_resource.SampleAdmin.id
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
