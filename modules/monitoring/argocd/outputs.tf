############################################
# Argo CD Outputs
############################################
 
output "namespace" {
  description = "Argo CD namespace"
  value   	= var.namespace
}
 
output "helm_release_name" {
  description = "Argo CD Helm release name"
  value   	= helm_release.argocd.name
}
 
output "application_name" {
  description = "Argo CD application name"
  value   	= kubernetes_manifest.application.manifest.metadata.name
}
 
output "repository_url" {
  description = "Git repository monitored by Argo CD"
  value   	= var.git_repository_url
}
 
output "repository_path" {
  description = "Git path monitored by Argo CD"
  value   	= var.git_path
} 
