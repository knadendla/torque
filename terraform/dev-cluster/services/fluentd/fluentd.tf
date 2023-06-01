resource "helm_release" "fluentd" {
  name  = "logzio-fluentd"
  chart = "logzio-fluentd"
  repository = "https://logzio.github.io/logzio-helm"
  version = "0.7.0"
  namespace = "monitoring"
  create_namespace = true
  description = "deploy logzio-fluentd Helm chart using Terraform"
  replace = true
  set {
    name  = "secrets.logzioShippingToken"
    value = "test"
  }
  set {
    name  = "secrets.logzioListener"
    value = "test"
  }
  timeout = 600
}

