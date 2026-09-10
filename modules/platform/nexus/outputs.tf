output "security_group_id" {
  description = "Nexus security group ID"
  value       = aws_security_group.nexus.id
}

output "instance_id" {
  description = "Nexus EC2 instance ID"
  value       = aws_instance.nexus.id
}

output "private_ip" {
  description = "Nexus private IP address"
  value       = aws_instance.nexus.private_ip
}

output "nexus_port" {
  description = "Nexus application port"
  value       = var.nexus_port
}

output "cloudwatch_log_group_name" {
  description = "Nexus CloudWatch log group name"
  value       = aws_cloudwatch_log_group.nexus.name
}

output "data_volume_id" {
  description = "Persistent Nexus data EBS volume ID"
  value       = aws_ebs_volume.nexus_data.id
}

output "iam_policy_arn" {
  description = "Nexus IAM policy ARN"
  value       = aws_iam_policy.nexus.arn
}
