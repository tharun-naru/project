resource "aws_cloudwatch_dashboard" "monitoring" {
  dashboard_name = "${var.environment}-monitoring"

  dashboard_body = jsonencode({
    widgets = var.dashboard_widgets
  })
}
