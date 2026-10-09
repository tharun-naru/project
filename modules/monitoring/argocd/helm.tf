 ############################################
# Argo CD Helm Release
############################################
 
resource "helm_release" "argocd" {
  name         	= var.release_name
  namespace    	= var.namespace
  create_namespace = true
  repository   	= var.helm_repository
  chart        	= var.chart_name
  version      	= var.chart_version
  wait         	= true
  timeout      	= var.helm_timeout
  cleanup_on_fail  = true
 
  values = [
    yamlencode({
  	# CRDs
      crds = {
        install = var.install_crds
        keep	= var.keep_crds
  	}
 
  	# Global
      global = {
        logging = {
          format = var.log_format
          level  = var.log_level
        }
  	}
 
  	# Controller
      controller = {
        replicas = var.controller_replicas
  	}
 
  	# Server
      server = {
        replicas = var.server_replicas
        service = {
          type = var.server_service_type
        }
  	}
 
  	# Repo Server
      repoServer = {
        replicas = var.repo_server_replicas
  	}
 
  	# ApplicationSet
      applicationSet = {
        replicas = var.applicationset_replicas
  	}
 
  	# Notifications
      notifications = {
        enabled = var.notifications_enabled
  	}
 
  	# Prometheus annotations
      addPrometheusAnnotations = var.add_prometheus_annotations
	})
  ]
} 
