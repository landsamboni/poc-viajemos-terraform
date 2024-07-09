variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_cni_version" {
  description = "The version of the VPC CNI addon"
  type        = string
}

variable "kube_proxy_version" {
  description = "The version of the Kube Proxy addon"
  type        = string
}

variable "coredns_version" {
  description = "The version of the CoreDNS addon"
  type        = string
}

variable "pod_identity_agent_version" {
  description = "The version of the Pod Identity Agent addon"
  type        = string
}

variable "dependency" {
  description = "Resource to depend on to ensure correct ordering"
  type        = any
}
