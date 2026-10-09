locals {
  name_prefix = "var.projectname-{var.environment}"
 
  common_tags = merge(
    var.common_tags,
	{
      Project 	= var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Component   = "ArgoCD"
	}
  )
 
  application_labels = merge(
	{
      project 	= var.project_name
      environment = var.environment
      managed-by  = "terraform"
	},
    var.application_labels
  )
} 
