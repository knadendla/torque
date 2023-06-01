resource "helm_release" "prometheus" {
  name  = "prometheus"
  chart = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version = "40.3.1"
  namespace = "prometheus"
  create_namespace = true
  description = "deploy Prometheus stack Helm chart using Terraform"
  replace = true
  timeout = 600
}

