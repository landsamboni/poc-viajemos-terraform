variable "region" {
  description = "The AWS region to deploy the EKS cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs to use for the EKS cluster"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs to use for the EKS cluster and Fargate profile"
  type        = list(string)
}

variable "fargate_profile_name" {
  description = "The name of the Fargate profile"
  type        = string
}

variable "fargate_namespace" {
  description = "The namespace to use with the Fargate profile"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version to use for the EKS cluster"
  type        = string
}

variable "oidc_provider_enabled" {
  description = "Indicates whether the OIDC provider is enabled for the EKS cluster"
  type        = bool
}

# Las siguientes variables se deben calcular dentro del módulo y no se deben pasar desde el archivo principal.
# Puedes eliminarlas si ya no las necesitas aquí.

# variable "vpc_cni_role_arn" {
#   description = "The ARN of the IAM role for VPC CNI"
#   type        = string
# }

# variable "kube_proxy_role_arn" {
#   description = "The ARN of the IAM role for kube-proxy"
#   type        = string
# }

# variable "coredns_role_arn" {
#   description = "The ARN of the IAM role for CoreDNS"
#   type        = string
# }

variable "namespace" {
  description = "The namespace for the service account"
  type        = string
  default     = "default"
}

variable "service_account_name" {
  description = "The name of the service account"
  type        = string
  default     = "my-service-account"
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
