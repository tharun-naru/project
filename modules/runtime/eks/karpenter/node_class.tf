resource "kubernetes_manifest" "node_class" {

  for_each = var.deploy_karpenter_manifests ? var.karpenter_node_classes : {}

  manifest = {
    apiVersion = "karpenter.k8s.aws/v1"
    kind       = "EC2NodeClass"

    metadata = {
      name = each.key
    }

    spec = {
      amiFamily = each.value.ami_family

      # IAM role name, not ARN
      role = var.node_role_name

      amiSelectorTerms = [
        {
          alias = each.value.ami_alias
        }
      ]

      subnetSelectorTerms = [
        {
          tags = var.subnet_discovery_tags
        }
      ]

      securityGroupSelectorTerms = [
        {
          tags = var.security_group_discovery_tags
        }
      ]

      tags = merge(
        var.common_tags,
        {
          Name = "${var.node_name_prefix}-${each.key}"
        },
        var.node_discovery_tags
      )
    }
  }

  depends_on = [
    helm_release.karpenter
  ]
}
