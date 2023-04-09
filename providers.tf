terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "5.1.0"
    }
    random = {
      source  = "ContentSquare/random"
      version = "3.1.0"
    }
    bcrypt = {
      source  = "viktorradnai/bcrypt"
      version = "0.1.2"
    }
  }
}

provider "random" {
  # Configuration options
}

provider "bcrypt" {
}

provider "helm" {
  kubernetes {
    config_path = "./kube_config.yml"
  }
}

provider "argocd" {
  server_addr = "argocd.local:443"
  auth_token  = "1234..."
}
