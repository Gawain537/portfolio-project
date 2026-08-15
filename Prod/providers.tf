terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.11.0"
    }


  }
}

provider "azurerm" {
  subscription_id = var.ARM_SUBSCRIPTION_ID

  features {}
}