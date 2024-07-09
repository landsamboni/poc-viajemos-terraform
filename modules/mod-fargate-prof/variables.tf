variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "fargate_profile_name" {
  description = "The name of the Fargate profile"
  type        = string
}

variable "pod_execution_role_arn" {
  description = "ARN of the pod execution role"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the Fargate profile"
  type        = list(string)
}

variable "fargate_namespace" {
  description = "Namespace for the Fargate profile"
  type        = string
}

variable "dependency" {
  description = "Resource to depend on to ensure correct ordering"
  type        = any
}
