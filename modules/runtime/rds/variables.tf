############################################
# Project Information
############################################

variable "project_name" {

  description = "Project name"

  type = string

}

variable "environment" {

  description = "Environment"

  type = string

}

variable "common_tags" {

  description = "Common tags"

  type = map(string)

  default = {}

}

############################################
# Networking
############################################

variable "vpc_id" {

  description = "VPC ID"

  type = string

}

variable "private_subnet_ids" {

  description = "Private subnet IDs"

  type = list(string)

}

############################################
# Database
############################################

variable "identifier" {

  description = "Database identifier"

  type = string

}

variable "engine" {

  description = "Database engine"

  type = string

  default = "postgres"

}

variable "engine_version" {

  description = "Database engine version"

  type = string

}

variable "instance_class" {

  description = "RDS instance class"

  type = string

}

variable "allocated_storage" {

  description = "Allocated storage (GB)"

  type = number

}

variable "storage_type" {

  description = "Storage type"

  type = string

  default = "gp3"

}

variable "storage_encrypted" {

  description = "Enable storage encryption"

  type = bool

  default = true

}

variable "kms_key_arn" {

  description = "KMS Key ARN"

  type = string

  default = null

}

variable "database_name" {

  description = "Initial database name"

  type = string

}

variable "master_username" {

  description = "Master username"

  type = string

}

variable "manage_master_user_password" {

  description = "Let Amazon RDS manage the master user password in AWS Secrets Manager"

  type    = bool
  default = true

}

variable "master_user_secret_kms_arn" {

  description = "KMS key ARN used to encrypt the RDS managed master user secret"

  type    = string
  default = null

}

############################################
# Availability
############################################

variable "multi_az" {

  description = "Enable Multi-AZ"

  type = bool

  default = false

}

variable "publicly_accessible" {

  description = "Public database"

  type = bool

  default = false

}

############################################
# Backup
############################################

variable "backup_retention_period" {

  description = "Backup retention"

  type = number

  default = 7

}

variable "backup_window" {

  description = "Preferred backup window"

  type = string

  default = null

}

############################################
# Maintenance
############################################

variable "maintenance_window" {

  description = "Preferred maintenance window"

  type = string

  default = null

}

variable "apply_immediately" {

  description = "Apply changes immediately"

  type = bool

  default = false

}

############################################
# Monitoring
############################################

variable "monitoring_interval" {

  description = "Enhanced Monitoring interval"

  type = number

  default = 60

}

variable "performance_insights_enabled" {

  description = "Enable Performance Insights"

  type = bool

  default = true

}

############################################
# Deletion Protection
############################################

variable "deletion_protection" {

  description = "Enable deletion protection"

  type = bool

  default = true

}

variable "skip_final_snapshot" {

  description = "Skip final snapshot"

  type = bool

  default = false

}

############################################
# CloudWatch Logs
############################################

variable "enabled_cloudwatch_logs_exports" {

  description = "Database logs to export"

  type = list(string)

  default = []

}

############################################
# Security Group
############################################

variable "security_group_ingress" {

  description = "Ingress rules"

  type = map(object({

    description = optional(string)

    from_port = number

    to_port = number

    protocol = string

    cidr_blocks = optional(list(string), [])

    security_group_ids = optional(list(string), [])

  }))

  default = {}

}

############################################
# Parameter Group
############################################

variable "parameters" {

  description = "DB parameters"

  type = map(object({

    value = string

    apply_method = optional(string, "immediate")

  }))

  default = {}

}
############################################
# Backup Replication
############################################

variable "enable_backup_replication" {

  description = "Enable automated backup replication"

  type = bool

  default = false

}

variable "backup_kms_key_arn" {

  description = "KMS Key for replicated backups"

  type = string

  default = null

}
variable "parameter_group_family" {
  description = "RDS parameter group family"

  type = string
}
