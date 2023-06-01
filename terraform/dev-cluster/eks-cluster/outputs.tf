output "eks_oidc_arn" {
  value = module.eks.oidc_provider_arn
}

output "host" {
  value = data.aws_eks_cluster.eks.endpoint
}

output "token" {
  value = data.aws_eks_cluster_auth.eks.token
}

output "cluster_ca_certificate" {
  value = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
}