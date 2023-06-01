locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
    labels = {
      istio-injection = "enabled"
    }
  }
}

resource "helm_release" "istio-base" {
  name             = "istio-base"
  chart            = "base"
  repository       = local.istio_charts_url
  version = "1.15.2"
  namespace        = kubernetes_namespace.istio_system.metadata.0.name
  create_namespace = true
  description = "deploy istio base Helm chart using Terraform"
  replace = true
  timeout = 600
  cleanup_on_fail   = true
  force_update      = false
}

resource "helm_release" "istiod" {
  repository       = local.istio_charts_url
  chart            = "istiod"
  name             = "istiod"
  namespace        = kubernetes_namespace.istio_system.metadata.0.name
  create_namespace = true
  version = "1.15.2"
  depends_on       = [helm_release.istio-base]
  description = "deploy istio base Helm chart using Terraform"
  timeout = 600
  cleanup_on_fail   = true
  force_update      = false
  replace = true
}

resource "helm_release" "istio-ingress" {
  repository = local.istio_charts_url
  chart      = "gateway"
  name       = "istio-ingress"
  namespace        = kubernetes_namespace.istio_system.metadata.0.name
  version = "1.15.2"
  depends_on = [helm_release.istiod]
  description = "deploy istio ingress Helm chart using Terraform"
  timeout = 600
  cleanup_on_fail   = true
  force_update      = false
  replace = true
}
