module "eks" {
  source        = "./eks-cluster"
  account       = var.account
  cluster-name  = var.cluster-name
  role_arn      = var.role_arn
  role_username = var.role_username
  aws-region    = var.region
}

module "fluentd" {
  count  = var.fluentd ? 1 : 0
  source = "./services/fluentd"
  depends_on = [
    module.eks
  ]
}

module "prometheus-grafna" {
  count  = var.prometheus ? 1 : 0
  source = "./services/prometheus-grafana"
  depends_on = [
    module.eks
  ]
}

module "elk-stack" {
  count  = var.elk ? 1 : 0
  source = "./services/elk"
  depends_on = [
    module.eks
  ]
}

module "istio" {
  count  = var.istio ? 1 : 0
  source = "./services/istio"
  depends_on = [
    module.eks
  ]
}

module "istio-tools" {
  count  = var.istio ? 1 : 0
  source = "./services/istio-tools"
  depends_on = [
    module.istio
  ]
}
