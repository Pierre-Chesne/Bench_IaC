variable "rgName" {
  type    = string
  default = "RG_Bench_Terraform"
}
variable "location" {
  type    = string
  default = "westeurope"
}
variable "AppPlanServiceName" {
  type    = string
  default = "AppPlanService_Terraform"
}
variable "kind" {
  type    = string
  default = "Linux"

}
variable "WebSiteName" {
  type    = string
  default = "site-Terraform-007"
}
variable "dockerImage" {
  type    = string
  default = "nginxdemos/hello"
}
variable "dockerImageTag" {
  type    = string
  default = "latest"
}

resource "azurerm_app_service_plan" "AppPlanService" {
  name                = var.AppPlanServiceName
  location            = var.location
  resource_group_name = var.rgName
  kind                = var.kind
  reserved            = true
  sku {
    tier     = "Standard"
    size     = "B1"
    capacity = 1
  }
}

resource "azurerm_app_service" "WebSite" {
  name                = var.WebSiteName
  location            = var.location
  resource_group_name = var.rgName
  app_service_plan_id = azurerm_app_service_plan.AppPlanService.id
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL" = "https://index.docker.io"
    "DOCKER_REGISTRY_SERVER_USERNAME"    = ""
    "DOCKER_REGISTRY_SERVER_PASSWORD"    = ""    
    "WEBSITE_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
  site_config {
    linux_fx_version = "DOCKER|${var.dockerImage}:${var.dockerImageTag}"
  }
}
