terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.80.0"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.0" # Use the version you need
    }

  }
}

provider "azapi" {
  subscription_id = var.ARM_SUBSCRIPTION_ID
}

provider "azurerm" {
  subscription_id = var.ARM_SUBSCRIPTION_ID

  features {}
}