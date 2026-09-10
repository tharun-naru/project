variable "aws_region" {
  description = "AWS region where Jenkins will be deployed"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Jenkins server will be deployed"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID of the shared internet-facing ALB"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for the Jenkins EC2 instance"
  type        = string
}

variable "jenkins_instance_type" {
  description = "EC2 instance type for Jenkins"
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "Root OS volume size in GB"
  type        = number
  default     = 30
}

variable "data_volume_size" {
  description = "Jenkins persistent data volume size in GB"
  type        = number
  default     = 50
}

variable "data_volume_type" {
  description = "EBS volume type for Jenkins persistent data"
  type        = string
  default     = "gp3"
}

variable "jenkins_port" {
  description = "Port on which Jenkins listens"
  type        = number
  default     = 8080
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed EC2 monitoring"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags applied to Jenkins resources"
  type        = map(string)
  default     = {}
}
variable "cloudwatch_log_retention_days" {
  description = "Number of days to retain Jenkins CloudWatch logs"
  type        = number
  default     = 30
}
variable "iam_instance_profile_name" {
  description = "IAM instance profile name for Jenkins EC2"
  type        = string
}
