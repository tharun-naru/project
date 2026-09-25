resource "aws_sns_topic" "monitoring" {
  name = "${local.name_prefix}-alerts"

  tags = local.common_tags
}

resource "aws_sns_topic_subscription" "email" {
  count = var.alert_email != null ? 1 : 0

  topic_arn = aws_sns_topic.monitoring.arn

  protocol = "email"
  endpoint = var.alert_email
}
