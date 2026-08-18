resource "helm_release" "karpenter" {

  name       = "karpenter"

  repository = "oci://public.ecr.aws/karpenter"

  chart = "karpenter"
  
  version    = var.karpenter_version

  namespace = "karpenter"

  create_namespace = true

  wait = true

  timeout = 600

  values = [

    yamlencode({

      settings = {

        clusterName = var.cluster_name

        clusterEndpoint = var.cluster_endpoint

        interruptionQueue = aws_sqs_queue.interruption.name

      }

      serviceAccount = {

        create = true

        name = "karpenter"

        annotations = var.controller_role_arn == null ? {} : {
    "eks.amazonaws.com/role-arn" = var.controller_role_arn

        }

      }

    })

  ]

}
