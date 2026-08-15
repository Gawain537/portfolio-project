data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "rg-oconnor-portfolio"
}

resource "azurerm_storage_account" "storage_account" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name = "stoconnorportfolio"

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

  # SKU - Free or Standard
  sku_tier = "Standard"
  sku_size = "Standard"

  tags = {
    environment = "production"
    application = "myapp"
    managed_by  = "terraform"
  }
}
