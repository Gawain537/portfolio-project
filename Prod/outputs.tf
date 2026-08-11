output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage_account.name
}

output "primary_web_host" {
  value = azurerm_storage_account.storage_account.primary_web_host
}

# Output the deployment token for GitHub Actions
output "deployment_token" {
  description = "Deployment token for CI/CD"
  value       = azurerm_static_web_app.main.api_key
  sensitive   = true
}