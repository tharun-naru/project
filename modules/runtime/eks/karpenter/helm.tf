resource "helm_release" "karpenter" {

  name       = var.name
  repository = var.helm_repository
  chart      = var.chart_name
  version    = var.karpenter_version

  namespace        = var.namespace
  create_namespace = var.create_namespace

  wait    = var.wait
  timeout = var.timeout

  values = [
    yamlencode({

      settings = {
        clusterName       = var.cluster_name
        clusterEndpoint   = var.cluster_endpoint
        interruptionQueue = aws_sqs_queue.interruption.name
      }

      serviceAccount = {
        create = var.service_account_create
        name   = var.service_account_name

        annotations = var.controller_role_arn == null ? {} : {
          "eks.amazonaws.com/role-arn" = var.controller_role_arn
        }
      }

    })
  ]
}
