variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where Nexus is deployed"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for Nexus"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID of the shared ALB"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile created by the generic IAM module"
  type        = string
}

variable "nexus_instance_type" {
  description = "EC2 instance type for Nexus"
  type        = string
}

variable "root_volume_size" {
  description = "Root OS volume size in GB"
  type        = number
}

variable "data_volume_size" {
  description = "Persistent Nexus data volume size in GB"
  type        = number
}

variable "data_volume_type" {
  description = "EBS volume type for Nexus data"
  type        = string
}

variable "nexus_port" {
  description = "Nexus application port"
  type        = number
  default     = 8081
}

variable "enable_detailed_monitoring" {
  description = "Enable EC2 detailed monitoring"
  type        = bool
  default     = false
}

variable "cloudwatch_log_retention_days" {
  description = "CloudWatch log retention period"
  type        = number
  default     = 30
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
}
