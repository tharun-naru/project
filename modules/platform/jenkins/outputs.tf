output "security_group_id" {
  description = "Jenkins security group ID"
  value       = aws_security_group.jenkins.id
}

output "instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = aws_instance.jenkins.id
}

output "private_ip" {
  description = "Jenkins private IP address"
  value       = aws_instance.jenkins.private_ip
}

output "jenkins_port" {
  description = "Jenkins application port"
  value       = var.jenkins_port
}

output "cloudwatch_log_group_name" {
  description = "Jenkins CloudWatch log group name"
  value       = aws_cloudwatch_log_group.jenkins.name
}

output "data_volume_id" {
  description = "Persistent Jenkins data EBS volume ID"
  value       = aws_ebs_volume.jenkins_data.id
}
output "iam_policy_arn" {
  description = "Jenkins IAM policy ARN"
  value       = aws_iam_policy.jenkins.arn
}

