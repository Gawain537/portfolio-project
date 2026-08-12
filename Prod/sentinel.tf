resource "azurerm_resource_group" "sentinel_rg" {
  name     = "rg-sentinel-demo"
  location = var.resource_group_location
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-sentinel-demo"
  location            = azurerm_resource_group.sentinel_rg.location
  resource_group_name = azurerm_resource_group.sentinel_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.law.id
}
