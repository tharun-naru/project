resource "aws_cloudwatch_metric_alarm" "this" {
  for_each = {
    for name, alarm in var.alarms :
    name => alarm
    if alarm.enabled
  }

  alarm_name = each.value.alarm_name

  alarm_description = each.value.alarm_description

  namespace   = each.value.namespace
  metric_name = each.value.metric_name

  statistic = each.value.statistic
  period   = each.value.period

  evaluation_periods = each.value.evaluation_periods

  comparison_operator = each.value.comparison_operator
  threshold           = each.value.threshold

  dimensions = each.value.dimensions

  treat_missing_data = each.value.treat_missing_data

  alarm_actions = [
    aws_sns_topic.monitoring.arn
  ]

  tags = local.common_tags
}
