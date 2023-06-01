module "cert_manager" {
  source               = "terraform-iaac/cert-manager/kubernetes"
  version              = "2.2.2"
  cluster_issuer_email = "admin@your-organization.com"
}
