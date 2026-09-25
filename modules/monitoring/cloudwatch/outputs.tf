output "sns_topic_arn" {
  description = "SNS topic ARN used for CloudWatch alerts"
  value       = aws_sns_topic.monitoring.arn
}

output "sns_topic_name" {
  description = "SNS topic name used for CloudWatch alerts"
  value       = aws_sns_topic.monitoring.name
}

output "alarm_names" {
  description = "CloudWatch alarm names"
  value = {
    for name, alarm in aws_cloudwatch_metric_alarm.this :
    name => alarm.alarm_name
  }
}

output "dashboard_name" {
  description = "CloudWatch monitoring dashboard name"
  value       = aws_cloudwatch_dashboard.monitoring.dashboard_name
}
