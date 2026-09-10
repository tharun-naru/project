resource "aws_cloudwatch_log_group" "sonarqube" {
  name              = "/${var.project_name}/${var.environment}/sonarqube"
  retention_in_days = var.cloudwatch_log_retention_days

  tags = merge(
    local.sonarqube_tags,
    {
      Name = "${local.sonarqube_name}-logs"
    }
  )
}
