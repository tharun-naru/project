############################################
# AWS Load Balancer Controller
############################################

resource "helm_release" "this" {

  ##########################################
  # Release
  ##########################################

  name = var.chart_name

  ##########################################
  # Chart
  ##########################################

  repository = var.helm_repository

  chart = var.chart_name

  version = var.chart_version

  ##########################################
  # Kubernetes
  ##########################################

  namespace = var.namespace

  create_namespace = var.create_namespace

  ##########################################
  # Helm Behaviour
  ##########################################

  wait = true

  timeout = 600

  ##########################################
  # EKS Cluster
  ##########################################

  set {

    name = "clusterName"

    value = var.cluster_name

  }

  ##########################################
  # AWS Region
  ##########################################

  set {

    name = "region"

    value = data.aws_region.current.name

  }

  ##########################################
  # VPC
  ##########################################

  set {

    name = "vpcId"

    value = var.vpc_id

  }

  ##########################################
  # Service Account
  ##########################################

  set {

    name = "serviceAccount.create"

    value = "true"

  }

  set {

    name = "serviceAccount.name"

    value = var.service_account_name

  }

  ##########################################
  # Existing IRSA Role
  ##########################################

  set {

    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"

    value = var.irsa_role_arn

  }

}
