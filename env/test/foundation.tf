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
