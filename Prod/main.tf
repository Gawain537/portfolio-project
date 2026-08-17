data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "rg-oconnor-${var.environment}"
  tags     = local.default_tags
}

resource "azurerm_storage_account" "storage_account" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags     = local.default_tags

  name = "stoconnor${var.environment}"

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  
  # The static_website block has been removed from here!
}

resource "azurerm_storage_account_static_website" "static_website" {
  storage_account_id = azurerm_storage_account.storage_account.id
  
  index_document     = "index.html"
}


resource "azurerm_static_web_app" "main" {
  name                = "swa-myapp-prod"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags     = local.default_tags
  # SKU - Free or Standard
  sku_tier = "Standard"
  sku_size = "Standard"

  lifecycle {
    ignore_changes = [
      repository_url,
      repository_branch,
    ]
  }
}

resource "azapi_resource" "ai_foundry" {
  type                      = "Microsoft.CognitiveServices/accounts@2025-06-01"
  name                      = "aifoundry-oconnor-${var.environment}"
  parent_id                 = azurerm_resource_group.rg.id
  location                  = var.resource_group_location
  schema_validation_enabled = false

  body = {
    kind = "AIServices"
    sku = {
      name = "S0"
    }
    identity = {
      type = "SystemAssigned"
    }

    properties = {
      # Support both Entra ID and API Key authentication for Cognitive Services account
      disableLocalAuth = false

      # Specifies that this is an AI Foundry resourceyes
      allowProjectManagement = true

      # Set custom subdomain name for DNS names created for this Foundry resource
      customSubDomainName = "aifoundry-oconnor-${var.environment}"
    }
  }
}

resource "azapi_resource" "ai_foundry_project" {
  type                      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
  name                      = "foundry-project-oconnor-${var.environment}"
  parent_id                 = azapi_resource.ai_foundry.id
  location                  = var.resource_group_location
  schema_validation_enabled = false
  tags     = local.default_tags

  body = {
    sku = {
      name = "S0"
    }
    identity = {
      type = "SystemAssigned"
    }

    properties = {
      displayName = "foundry-project-oconnor-${var.environment}"
      description = "My first project"
    }
  }
}

resource "azapi_resource" "aifoundry_deployment_gpt_4o" {
  type      = "Microsoft.CognitiveServices/accounts/deployments@2023-05-01"
  name      = "gpt-5.4-nano"
  parent_id = azapi_resource.ai_foundry.id
  depends_on = [
    azapi_resource.ai_foundry
  ]

  body = {
    sku = {
      name     = "GlobalStandard"
      capacity = 1
    }
    properties = {
      model = {
        format  = "OpenAI"
        name    = "gpt-5.4-nano"
        version = "2026-03-17"
      }
    }
  }
}