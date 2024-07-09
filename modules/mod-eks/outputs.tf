output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "eks_cluster" {
  description = "The EKS cluster resource"
  value       = aws_eks_cluster.this
}

/* output "vpc_cni_role_arn" {
  value = module.iam.vpc_cni_role_arn
}

output "kube_proxy_role_arn" {
  value = module.iam.kube_proxy_role_arn
}

output "coredns_role_arn" {
  value = module.iam.coredns_role_arn
} */
