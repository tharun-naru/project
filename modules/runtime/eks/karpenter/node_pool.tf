resource "kubernetes_manifest" "node_pool" {

 for_each = var.deploy_karpenter_manifests ? var.karpenter_node_pools : {}

  manifest = {

    apiVersion = "karpenter.sh/v1"

    kind = "NodePool"

    metadata = {

      name = each.key

    }

    spec = {

     template = {

  spec = {

    nodeClassRef = {

      group = "karpenter.k8s.aws"

      kind  = "EC2NodeClass"

      name  = each.value.node_class

    }

    expireAfter = each.value.expire_after

    requirements = [

      {

        key = "karpenter.k8s.aws/instance-family"

        operator = "In"

        values = each.value.instance_families

      },

      {

        key = "karpenter.sh/capacity-type"

        operator = "In"

        values = each.value.capacity_types

      },

      {

        key = "kubernetes.io/arch"

        operator = "In"

        values = ["amd64"]

      },

      {

        key = "kubernetes.io/os"

        operator = "In"

        values = ["linux"]

      }

    ]

  }

}

limits = {

  cpu    = each.value.cpu_limit

  memory = each.value.memory_limit

}

disruption = {

  consolidationPolicy = each.value.consolidation_policy
  consolidateAfter = each.value.consolidate_after
} 

    }

  }

  depends_on = [
    helm_release.karpenter,
    kubernetes_manifest.node_class

  ]

}
