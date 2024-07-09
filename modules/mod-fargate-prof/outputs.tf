output "fargate_profile_name" {
  description = "The name of the Fargate profile"
  value       = aws_eks_fargate_profile.this.fargate_profile_name
}
