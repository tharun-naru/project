module "karpenter" {

  source = "./karpenter"

  count = var.enable_karpenter ? 1 : 0

  providers = {

    kubernetes = kubernetes

    helm = helm

  }

  ####################################################
  # EKS
  ####################################################

  cluster_name     = aws_eks_cluster.this.name
  cluster_endpoint = aws_eks_cluster.this.endpoint

  ####################################################
  # IAM
  ####################################################

  controller_role_arn = aws_iam_role.karpenter_controller.arn
  node_role_arn       = var.node_role_arn

  ####################################################
  # Karpenter Configuration
  ####################################################

  karpenter_node_classes = var.karpenter_node_classes
  karpenter_node_pools   = var.karpenter_node_pools
  deploy_karpenter_manifests  = var.deploy_karpenter_manifests
  ####################################################
  # Common
  ####################################################

  common_tags = local.common_tags

  depends_on = [

    aws_eks_cluster.this,
    aws_eks_addon.this,
    aws_iam_role.karpenter_controller,
    aws_eks_access_entry.this,
    aws_eks_access_policy_association.this

  ]

}
