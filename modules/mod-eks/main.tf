module "oidc" {
  source       = "../../modules/mod-oidc"
  cluster_name = var.cluster_name
  region       = var.region
}

module "iam" {
  source       = "../../modules/mod-iam"
  cluster_name = var.cluster_name
  eks_service_account_assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = module.oidc.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "oidc.eks.${var.region}.amazonaws.com/id/${var.cluster_name}:sub" : "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      }
    ]
  })
}

# -------------------------------------------------------------
#                           EKS CLUSTER
# -------------------------------------------------------------
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = module.iam.eks_cluster_role_arn

  vpc_config {
    subnet_ids              = concat(var.public_subnet_ids, var.private_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = merge(var.tags, {
    "alpha.eksctl.io/cluster-oidc-enabled" = "true"
  })

  depends_on = [
    module.iam.cluster_AmazonEKSClusterPolicy,
    module.iam.cluster_AmazonEKSVPCResourceController,
    module.oidc,
  ]
}


# -------------------------------------------------------------
#                           NODE GROUP
# -------------------------------------------------------------

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "node-group-1"
  node_role_arn   = module.iam.eks_node_group_role_arn
  subnet_ids      = var.private_subnet_ids
  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["t3.medium"]

  depends_on = [
    aws_eks_cluster.this
  ]
}




# -------------------------------------------------------------
#                           PERFIL FARGATE
# -------------------------------------------------------------

module "fargate" {
  source                 = "../../modules/mod-fargate-prof"
  cluster_name           = aws_eks_cluster.this.name
  fargate_profile_name   = var.fargate_profile_name
  pod_execution_role_arn = module.iam.fargate_pod_execution_role_arn
  private_subnet_ids     = var.private_subnet_ids
  fargate_namespace      = var.fargate_namespace
  dependency             = aws_eks_cluster.this
}


# -------------------------------------------------------------
#                          CLUSTER ADD ONS
# -------------------------------------------------------------
resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.this.name
  addon_name                  = "vpc-cni"
  addon_version               = "v1.18.2-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  #service_account_role_arn    = one(module.vpc_cni_eks_iam_role[*].service_account_role_arn)

  depends_on = [
    aws_eks_cluster.this
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                  = aws_eks_cluster.this.name
  addon_name                    = "kube-proxy"
  addon_version                 = null
  resolve_conflicts_on_create   = "OVERWRITE"
  resolve_conflicts_on_update   = "PRESERVE"
  service_account_role_arn      = null

  depends_on = [
    aws_eks_cluster.this
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name                  = aws_eks_cluster.this.name
  addon_name                    = "coredns"
  addon_version                 = "v1.11.1-eksbuild.9"
  resolve_conflicts_on_create   = "NONE"
  resolve_conflicts_on_update   = "PRESERVE"
  service_account_role_arn      = null

  depends_on = [
    aws_eks_cluster.this
  ]
}