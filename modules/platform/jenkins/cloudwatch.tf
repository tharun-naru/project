resource "aws_cloudwatch_log_group" "jenkins" {
  name              = "/${var.project_name}/${var.environment}/jenkins"
  retention_in_days = var.cloudwatch_log_retention_days

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-jenkins-logs"
    }
  )
}
