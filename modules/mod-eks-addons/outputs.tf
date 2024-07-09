output "vpc_cni_addon_name" {
  description = "The name of the VPC CNI addon"
  value       = aws_eks_addon.vpc_cni.addon_name
}

output "kube_proxy_addon_name" {
  description = "The name of the Kube Proxy addon"
  value       = aws_eks_addon.kube_proxy.addon_name
}

output "coredns_addon_name" {
  description = "The name of the CoreDNS addon"
  value       = aws_eks_addon.coredns.addon_name
}

output "pod_identity_agent_addon_name" {
  description = "The name of the Pod Identity Agent addon"
  value       = aws_eks_addon.pod_identity_agent.addon_name
}
