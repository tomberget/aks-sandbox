terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
  }

  backend "azurerm" {
    resource_group_name  = "iac"
    storage_account_name = "terraformstate5089a"
    container_name       = "tfstate"
    key                  = "default.terraform.tfstate"
  }

  required_version = "~> 1.2"
}

provider "azurerm" {
  features {
  }
}


provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
}

provider "helm" {
  kubernetes {
  }
}
