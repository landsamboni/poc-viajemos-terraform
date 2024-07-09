variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "eks_service_account_assume_role_policy" {
  description = "The assume role policy for the EKS service account"
  type        = string
}
