terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
  }
}

# Configure the Kubernetes provider
provider "kubernetes" {
  config_path    = "~/.kube/config"  # Path to your kubeconfig file
  config_context = "kind-kind"  # Change this to your local context
}

# Configure the Helm provider
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "kind-kind"  # Change this to your local context
  }
}