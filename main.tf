# -------------------------------------------------------------
#                           VPC
# -------------------------------------------------------------
module "vpc" {
  source    = "cloudposse/vpc/aws"
  version   = "2.1.1"
  namespace = "viajemos"
  stage     = "test"
  name      = "vpc"

  ipv4_primary_cidr_block          = "10.0.0.0/16"
  default_security_group_deny_all  = false
  assign_generated_ipv6_cidr_block = false
}

locals {
  public_subnets_additional_tags = {
    "kubernetes.io/role/elb" : 1
  }
  private_subnets_additional_tags = {
    "kubernetes.io/role/internal-elb" : 1
  }
}

# VPC Subnets 
module "dynamic_subnets" {
  source             = "cloudposse/dynamic-subnets/aws"
  version            = "2.4.2"
  namespace          = "viajemos"
  stage              = "test"
  name               = "subnet"
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 3) #toma las 3 primeras AZ de la región
  vpc_id             = module.vpc.vpc_id
  igw_id             = [module.vpc.igw_id]

  public_subnets_additional_tags  = local.public_subnets_additional_tags
  private_subnets_additional_tags = local.private_subnets_additional_tags

  tags = { "kubernetes.io/cluster/viajemos-eks-cluster" = "shared" }
}

# Default SG for VPC 
resource "aws_default_security_group" "default" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "${module.vpc.vpc_id}-default-sg"
  }

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# -------------------------------------------------------------
#                           ECR
# -------------------------------------------------------------
module "ecr" {
  source               = "./modules/mod-ecr"
  region               = var.region
  repository_name      = "viajemos-dev-ecr-repo"
  image_tag_mutability = "IMMUTABLE"
  image_scan_on_push   = true
  encryption_type      = "AES256"
}




# -------------------------------------------------------------
#                           EKS CLUSTER
# -------------------------------------------------------------
module "eks_fargate" {
  source       = "./modules/mod-eks"
  region       = "us-east-1"
  cluster_name = "viajemos-eks-cluster"

  public_subnet_ids  = module.dynamic_subnets.public_subnet_ids
  private_subnet_ids = module.dynamic_subnets.private_subnet_ids

  fargate_profile_name = "viajemos-fargate-profile"
  fargate_namespace    = "*" # "default"

  kubernetes_version    = "1.30"
  oidc_provider_enabled = true

  namespace            = "default"
  service_account_name = "viajemos-service-account"
}

