# -------------------------------------------------------------
#                       OIDC
# -------------------------------------------------------------
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  url             = "https://oidc.eks.${var.region}.amazonaws.com/id/${var.cluster_name}"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960e5e4e1d5f2d9ebd9b9c5d1b7c9c3"] # Thumbprint de Amazon Root CA 1
}
