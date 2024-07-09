output "eks_cluster_name" {
  value = module.eks_fargate.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks_fargate.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value = module.eks_fargate.cluster_certificate_authority_data
}
