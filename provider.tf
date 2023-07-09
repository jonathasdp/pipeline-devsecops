terraform {
  required_version = ">=1.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.5"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-storageaccount"
    storage_account_name = "stpipelinedevsecops"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-atividade" {
  name     = "rg-atividade"
  location = "West US"

  tags = {
    faculdade = "Impacta"
  }
}
