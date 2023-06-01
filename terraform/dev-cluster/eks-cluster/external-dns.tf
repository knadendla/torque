module "iam-role-for-external-dns" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.3.3"

  attach_external_dns_policy = true
  oidc_providers = {
    provider = {
      provider_arn = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}

resource "helm_release" "external_dns" {
  depends_on = [
    module.iam-role-for-external-dns
  ]
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  namespace        = "kube-system"
  create_namespace = false

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "sources"
    value = "{service,ingress}"
  }

  # policy=upsert-only - would prevent ExternalDNS from deleting any records,
  # policy=sync        - to enable full synchronization
  set {
    name  = "policy"
    value = "sync"
  }

  # only look at public hosted zones (valid values are public, private or no value for both)
  set {
    name  = "aws.zoneType"
    value = "public"
  }

  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }
}