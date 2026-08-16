variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
  default     = "eastus2"
}

variable "ARM_SUBSCRIPTION_ID" {
  type        = string
  description = "The Azure Subscription ID"
  default    = "4c7d4e4e-eee6-40d3-8d69-edbb861b2345"
}

variable "environment" {
  type    = string
  default = "portfolio"
}