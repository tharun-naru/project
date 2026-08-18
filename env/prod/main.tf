############################################
# Networking
############################################

module "networking" {

  source = "../../modules/foundation/networking"

  region = var.region

  project_name = var.project_name

  environment = var.environment

  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs = var.public_subnet_cidrs

  private_subnet_cidrs = var.private_subnet_cidrs

  nat_gateway_count = var.nat_gateway_count

  availability_zone_indexes = var.availability_zone_indexes

  karpenter_discovery_tag = "speshway-prod-eks"
}
############################################
# VPC ENDPOINTS
############################################

module "vpc_endpoints" {

  source = "../../modules/foundation/vpc-endpoints"

  project_name = var.project_name

  environment = var.environment

  vpc_id = module.networking.vpc_id

  private_route_table_ids = module.networking.private_route_table_ids

  private_subnet_ids = module.networking.private_subnet_ids

  gateway_endpoints = var.gateway_vpc_endpoints

  interface_endpoints = var.interface_vpc_endpoints

  interface_endpoint_ingress_cidr_blocks = var.vpc_endpoint_ingress_cidrs

  common_tags = local.common_tags
}

############################################
# IAM
############################################
module "iam" {
  source       = "../../modules/foundation/iam"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = local.common_tags

  iam_roles    = var.iam_roles
  iam_policies = var.iam_policies
}

############################################
# KMS
############################################

module "kms" {

  source = "../../modules/foundation/kms"

  project_name = var.project_name

  environment = var.environment

  common_tags = local.common_tags

  kms_keys = var.kms_keys

}
############################################
# ECR
############################################
module "ecr" {

  source = "../../modules/runtime/ecr"

  project_name = var.project_name

  environment = var.environment

  common_tags = var.common_tags

  repositories = var.ecr_repositories

  kms_key_arn = module.kms.kms_key_arns["ecr"]
}
############################################
# EKS
############################################
module "eks" {

  source = "../../modules/runtime/eks"

  project_name = var.project_name

  environment = var.environment

  vpc_id = module.networking.vpc_id

  private_subnet_ids = module.networking.private_subnet_ids

  cluster_role_arn = module.iam.role_arns["eks_cluster"]

  node_role_arn = module.iam.role_arns["eks_node"]
  
  launch_templates   = var.launch_templates
  eks_access_entries = var.eks_access_entries

  cluster_version = var.eks_cluster_version

  endpoint_private_access = var.endpoint_private_access

  endpoint_public_access = var.endpoint_public_access

  public_access_cidrs = var.public_access_cidrs

  kms_key_arn = module.kms.kms_key_arns["eks"]

  node_groups = var.eks_node_groups

  addons = var.addons

  enable_oidc = true

  irsa_roles = {
    for role_name, role in var.eks_irsa_roles :
    role_name => {
      namespace       = role.namespace
      service_account = role.service_account

      policy_arns = concat(
        try(role.policy_arns, []),
        [
          for policy_name in try(role.policy_names, []) :
          module.iam.policy_arns[policy_name]
        ]
      )
    }
  }

  cluster_log_types = var.cluster_log_types

  cluster_log_retention_in_days = var.cluster_log_retention_in_days

  cluster_log_kms_key_arn = var.cluster_log_kms_key_arn

  common_tags = local.common_tags

  enable_karpenter = var.enable_karpenter

  karpenter_version = var.karpenter_version

  deploy_karpenter_manifests = true

  karpenter_node_classes = var.karpenter_node_classes

  karpenter_node_pools = var.karpenter_node_pools

  create_additional_security_group = false

  karpenter_discovery_tag = "speshway-prod-eks"
}
############################################
# RDS 
############################################

module "rds" {

  source = "../../modules/runtime/rds"

  project_name = var.project_name
  environment  = var.environment

  identifier = var.rds.identifier

  engine = var.rds.engine

  engine_version = var.rds.engine_version

  instance_class = var.rds.instance_class

  allocated_storage = var.rds.allocated_storage

  storage_type = var.rds.storage_type

  storage_encrypted = var.rds.storage_encrypted

  database_name = var.rds.database_name

  master_username = var.rds.master_username

  manage_master_user_password = var.rds.manage_master_user_password

  master_user_secret_kms_arn = module.kms.kms_key_arns["rds"]

  publicly_accessible = var.rds.publicly_accessible

  multi_az = var.rds.multi_az

  backup_retention_period = var.rds.backup_retention_period

  backup_window = var.rds.backup_window

  maintenance_window = var.rds.maintenance_window

  deletion_protection = var.rds.deletion_protection

  skip_final_snapshot = var.rds.skip_final_snapshot

  vpc_id = module.networking.vpc_id

  private_subnet_ids = module.networking.private_subnet_ids

  parameter_group_family = var.rds.parameter_group_family
}
