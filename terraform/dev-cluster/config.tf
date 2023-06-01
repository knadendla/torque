terraform {
  required_version = ">=1.1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "helm" {
    kubernetes {
        host                   = module.eks.host
        cluster_ca_certificate = module.eks.cluster_ca_certificate
        token                  = module.eks.token
    }
}

provider "kubectl" {
    host                   = module.eks.host
    cluster_ca_certificate = module.eks.cluster_ca_certificate
    token                  = module.eks.token
    load_config_file       = "false"
}

provider "kubernetes" {
    host                   = module.eks.host
    cluster_ca_certificate = module.eks.cluster_ca_certificate
    token                  = module.eks.token
}
