resource "aws_cloudwatch_log_group" "nexus" {
  name              = "/${var.project_name}/${var.environment}/nexus"
  retention_in_days = var.cloudwatch_log_retention_days

  tags = merge(
    local.nexus_tags,
    {
      Name = "${local.nexus_name}-logs"
    }
  )
}
