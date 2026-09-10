locals {
  jenkins_name = "${var.project_name}-${var.environment}-jenkins"

  common_tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Service     = "Jenkins"
    }
  )

  jenkins_tags = merge(
    local.common_tags,
    {
      Name = local.jenkins_name
    }
  )
}
