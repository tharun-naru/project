############################################
# Argo CD Application
############################################
 
resource "kubernetes_manifest" "application" {
  depends_on = [
    helm_release.argocd
  ]
 
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind   	= "Application"
 
    metadata = {
      name  	= var.application_name
      namespace = var.namespace
      labels	= local.application_labels
	}
 
	spec = {
      project = var.argocd_project
 
      source = {
        repoURL    	= var.git_repository_url
        targetRevision = var.git_target_revision
        path       	= var.git_path
  	}
 
      destination = {
        server	= var.destination_server
        namespace = var.destination_namespace
  	}
 
      syncPolicy = {
        automated = {
          prune	= var.sync_prune
          selfHeal = var.sync_self_heal
        }
        syncOptions = var.sync_options
  	}
	}
  }
}
 
############################################
# Keep existing state after the rename
# (old name: kubernetes_manifest.speshway_crm)
############################################
 
moved {
  from = kubernetes_manifest.speshway_crm
  to   = kubernetes_manifest.application
}
