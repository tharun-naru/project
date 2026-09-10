############################################
# Helm Release
############################################

output "helm_release_name" {

  description = "AWS Load Balancer Controller Helm release name"

  value = helm_release.this.name

}

############################################
# Namespace
############################################

output "namespace" {

  description = "Kubernetes namespace"

  value = var.namespace

}

############################################
# Service Account
############################################

output "service_account_name" {

  description = "AWS Load Balancer Controller service account"

  value = var.service_account_name

}

############################################
# Controller Name
############################################

output "controller_name" {

  description = "AWS Load Balancer Controller name"

  value = local.controller_name

}
