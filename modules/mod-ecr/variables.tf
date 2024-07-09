variable "repository_name" {
  description = "The name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Valid values are MUTABLE and IMMUTABLE"
  type        = string
  default     = "MUTABLE"
}

variable "image_scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "The encryption type to use for the repository. Valid values are AES256 and KMS"
  type        = string
  default     = "AES256"
}

variable "region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-east-1"

}

