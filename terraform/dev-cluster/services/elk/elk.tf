resource "helm_release" "elasticsearch" {
  name  = "elasticsearch"
  chart = "elasticsearch"
  repository = "https://helm.elastic.co"
  version = "7.17.3"
  namespace = "elk"
  create_namespace = true
  description = "deploy elasticsearch Helm chart using Terraform"
  replace = true
    set {
    name  = "antiAffinity"
    value = "soft"
  }
  timeout = 600
}

resource "helm_release" "kibana" {
  name  = "kibana"
  chart = "kibana"
  repository = "https://helm.elastic.co"
  version = "7.17.3"
  namespace = "elk"
  create_namespace = true
  description = "deploy kibana Helm chart using Terraform"
  replace = true
  timeout = 600
}

resource "helm_release" "filebeat" {
  name  = "filebeat"
  chart = "filebeat"
  repository = "https://helm.elastic.co"
  version = "7.17.3"
  namespace = "elk"
  create_namespace = true
  description = "deploy filebeat Helm chart using Terraform"
  replace = true
  timeout = 600
}

