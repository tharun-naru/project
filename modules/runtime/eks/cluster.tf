resource "aws_eks_cluster" "this" {

  name = local.cluster_name

  version = var.cluster_version

  role_arn = var.cluster_role_arn

  access_config {
  authentication_mode = "API_AND_CONFIG_MAP"
  bootstrap_cluster_creator_admin_permissions = false
 }

  enabled_cluster_log_types = var.cluster_log_types

  depends_on = [
    aws_cloudwatch_log_group.eks
  ]     

  vpc_config {

    subnet_ids = var.private_subnet_ids

    endpoint_private_access = var.endpoint_private_access

    endpoint_public_access = var.endpoint_public_access

    public_access_cidrs = var.endpoint_public_access ? var.public_access_cidrs : null

  }

  dynamic "encryption_config" {

    for_each = var.kms_key_arn == null ? [] : [var.kms_key_arn]

    content {

      provider {

        key_arn = encryption_config.value

      }

      resources = [

        "secrets"

      ]

    }

  }

  tags = merge(

    local.common_tags,

    {

      Name = local.cluster_name

    }

  )

}
