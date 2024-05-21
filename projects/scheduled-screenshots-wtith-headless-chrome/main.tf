provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "observability" {
  name     = "observability-2"
  location = "ukwest"
}

resource "azurerm_storage_account" "results" {
  name                     = "obstorageresults"
  resource_group_name      = azurerm_resource_group.observability.name
  location                 = azurerm_resource_group.observability.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "serviceplan" {
  name                = "ob-service-plan"
  resource_group_name = azurerm_resource_group.observability.name
  location            = azurerm_resource_group.observability.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "example" {
  name                = "synthetic-scan"
  resource_group_name = azurerm_resource_group.observability.name
  location            = azurerm_resource_group.observability.location

  storage_account_name       = azurerm_storage_account.results.name
  storage_account_access_key = azurerm_storage_account.results.primary_access_key
  service_plan_id            = azurerm_service_plan.serviceplan.id

  site_config {}
}
