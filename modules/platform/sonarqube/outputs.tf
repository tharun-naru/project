output "security_group_id" {
  description = "SonarQube security group ID"
  value       = aws_security_group.sonarqube.id
}

output "instance_id" {
  description = "SonarQube EC2 instance ID"
  value       = aws_instance.sonarqube.id
}

output "private_ip" {
  description = "SonarQube private IP address"
  value       = aws_instance.sonarqube.private_ip
}

output "sonarqube_port" {
  description = "SonarQube application port"
  value       = var.sonarqube_port
}

output "cloudwatch_log_group_name" {
  description = "SonarQube CloudWatch log group name"
  value       = aws_cloudwatch_log_group.sonarqube.name
}

output "data_volume_ids" {
  description = "Persistent EBS volume IDs"
  value = {
    for name, volume in aws_ebs_volume.data :
    name => volume.id
  }
}

output "iam_policy_arn" {
  description = "SonarQube IAM policy ARN"
  value       = aws_iam_policy.sonarqube.arn
}
