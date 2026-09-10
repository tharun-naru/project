locals {
  sonarqube_name = "${var.project_name}-${var.environment}-sonarqube"

  sonarqube_tags = merge(
    var.common_tags,
    {
      Name    = local.sonarqube_name
      Service = "SonarQube"
    }
  )
}
