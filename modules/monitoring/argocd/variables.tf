############################################
# Project
############################################
 
variable "project_name" {
  description = "Project name"
  type    	= string
}
 
variable "environment" {
  description = "Environment name"
  type    	= string
}
 
variable "common_tags" {
  description = "Common project tags"
  type    	= map(string)
  default 	= {}
}
 
############################################
# Kubernetes
############################################
 
variable "namespace" {
  description = "Argo CD namespace"
  type    	= string
  default 	= "argocd"
}
 
############################################
# Argo CD Helm
############################################
 
variable "release_name" {
  description = "Argo CD Helm release name"
  type    	= string
  default 	= "argocd"
}
 
variable "helm_repository" {
  description = "Argo CD Helm repository"
  type    	= string
  default 	= "https://argoproj.github.io/argo-helm"
}
 
variable "chart_name" {
  description = "Argo CD Helm chart name"
  type    	= string
  default 	= "argo-cd"
}
 
variable "chart_version" {
  description = "Argo CD Helm chart version"
  type    	= string
  default 	= "10.9.2"
}
 
variable "helm_timeout" {
  description = "Seconds to wait for the Helm release to be ready"
  type    	= number
  default 	= 900
}
 
variable "install_crds" {
  description = "Install Argo CD CRDs with the chart"
  type    	= bool
  default 	= true
}
 
variable "keep_crds" {
  description = "Keep Argo CD CRDs when the release is removed"
  type    	= bool
  default 	= true
}
 
variable "log_format" {
  description = "Argo CD log format (text or json)"
  type    	= string
  default 	= "json"
}
 
variable "log_level" {
  description = "Argo CD log level (debug, info, warn, error)"
  type    	= string
  default 	= "info"
}
 
variable "controller_replicas" {
  description = "Application controller replicas"
  type    	= number
  default 	= 1
}
 
variable "server_replicas" {
  description = "Argo CD server replicas"
  type    	= number
  default 	= 1
}
 
variable "repo_server_replicas" {
  description = "Repo server replicas"
  type    	= number
  default 	= 1
}
 
variable "applicationset_replicas" {
  description = "ApplicationSet controller replicas"
  type    	= number
  default 	= 1
}
 
variable "server_service_type" {
  description = "Argo CD server service type (ClusterIP, NodePort, LoadBalancer)"
  type    	= string
  default 	= "ClusterIP"
}
 
variable "notifications_enabled" {
  description = "Enable the Argo CD notifications controller"
  type    	= bool
  default 	= true
}
 
variable "add_prometheus_annotations" {
  description = "Add Prometheus scrape annotations to Argo CD services"
  type    	= bool
  default 	= true
}
 
############################################
# GitOps Repository
############################################
 
variable "git_repository_url" {
  description = "Git repository containing Kubernetes/Helm deployment configuration"
  type    	= string
}
 
variable "git_target_revision" {
  description = "Git branch, tag, or commit"
  type    	= string
  default 	= "HEAD"
}
 
variable "git_path" {
  description = "Path containing the application Helm chart"
  type    	= string
}
 
############################################
# Application
############################################
 
variable "application_name" {
  description = "Argo CD application name"
  type    	= string
}
 
variable "argocd_project" {
  description = "Argo CD project the application belongs to"
  type    	= string
  default 	= "default"
}
 
variable "destination_server" {
  description = "Kubernetes API server Argo CD deploys to (in-cluster by default)"
  type    	= string
  default 	= "https://kubernetes.default.svc"
}
 
variable "destination_namespace" {
  description = "Kubernetes namespace where the application is deployed"
  type    	= string
}
 
variable "sync_prune" {
  description = "Delete resources that are removed from Git"
  type    	= bool
  default 	= true
}
 
variable "sync_self_heal" {
  description = "Undo manual changes made in the cluster"
  type    	= bool
  default 	= true
}
 
variable "sync_options" {
  description = "Argo CD sync options"
  type   	 = list(string)
  default 	= ["CreateNamespace=true"]
}
 
variable "application_labels" {
  description = "Extra labels for the Argo CD Application"
  type    	= map(string)
  default 	= {}
} 
