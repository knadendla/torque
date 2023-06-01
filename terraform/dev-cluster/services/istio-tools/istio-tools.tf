terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}


data "kubectl_filename_list" "zipkin_manifests" {
    pattern = "${path.module}/zipkin/*.yaml"
}

resource "kubectl_manifest" "zipkin" {
    count = 3
    yaml_body = file(element(data.kubectl_filename_list.zipkin_manifests.matches, count.index))
}

data "kubectl_filename_list" "prometheus_manifests" {
    pattern = "${path.module}/prometheus/*.yaml"
}

resource "kubectl_manifest" "prometheus" {
    count = 6
    yaml_body = file(element(data.kubectl_filename_list.prometheus_manifests.matches, count.index))
}

data "kubectl_filename_list" "grafana_manifests" {
    pattern = "${path.module}/grafana/*.yaml"
}

resource "kubectl_manifest" "grafana" {
    count = 6
    yaml_body = file(element(data.kubectl_filename_list.grafana_manifests.matches, count.index))
}

data "kubectl_filename_list" "jaeger_manifests" {
    pattern = "${path.module}/jaeger/*.yaml"
}

resource "kubectl_manifest" "jaeger" {
    count = 4
    yaml_body = file(element(data.kubectl_filename_list.jaeger_manifests.matches, count.index))
}

data "kubectl_filename_list" "kiali_manifests" {
    pattern = "${path.module}/kiali/*.yaml"
}

resource "kubectl_manifest" "kiali" {
    count = 9
    yaml_body = file(element(data.kubectl_filename_list.kiali_manifests.matches, count.index))
}