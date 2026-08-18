resource "kubernetes_manifest" "node_class" {

 for_each = var.deploy_karpenter_manifests ? var.karpenter_node_classes : {}

  manifest = {

    apiVersion = "karpenter.k8s.aws/v1"

    kind = "EC2NodeClass"

    metadata = {

      name = each.key

    }

    spec = {

      amiFamily = each.value.ami_family

      role = var.node_role_arn

      amiSelectorTerms = [
       {
          alias = each.value.ami_alias
       }
      ]

      subnetSelectorTerms = [

        {
          tags = {

            "karpenter.sh/discovery" = var.cluster_name

          }
        }

      ]

      securityGroupSelectorTerms = [

        {
          tags = {

            "karpenter.sh/discovery" = var.cluster_name

          }
        }

      ]

      tags = merge(

        var.common_tags,

        {
          "Name" = "${var.cluster_name}-karpenter-${each.key}"

          "karpenter.sh/discovery" = var.cluster_name

        }

      )

    }

  }

  depends_on = [

    helm_release.karpenter

  ]

}
