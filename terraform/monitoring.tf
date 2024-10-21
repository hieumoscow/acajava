# monitoring.tf

# Application Insights
resource "azurerm_application_insights" "ais" {
  name                = "${var.name}-appinsights"
  location            = var.location
  resource_group_name = azurerm_resource_group.acarg.name
  application_type    = "web"
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.name}-law"
  location            = var.location
  resource_group_name = azurerm_resource_group.acarg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Diagnostic settings for Container App
resource "azurerm_monitor_diagnostic_setting" "app_logs" {
  name                       = "app_logs"
  target_resource_id         = azurerm_container_app_environment.env.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id


  enabled_log {
    category = "ContainerAppSystemLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
