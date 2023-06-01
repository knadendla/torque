resource "helm_release" "ingress-nginx-controller" {
  name  = "ingress-nginx"
  chart = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version = "4.2.5"
  namespace = "nginx"
  create_namespace = true
  description = "deploy ingress-nginx-controller Helm chart using Terraform"
  replace = true
}

