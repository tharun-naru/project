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
  description = "VPC ID for SonarQube"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for SonarQube"
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

variable "sonarqube_instance_type" {
  description = "EC2 instance type for SonarQube"
  type        = string
}

variable "root_volume_size" {
  description = "Root OS volume size in GB"
  type        = number
}

variable "data_volumes" {
  description = "Persistent EBS volumes for SonarQube and PostgreSQL"

  type = map(object({
    size        = number
    type        = string
    encrypted   = bool
    device_name = string
  }))
}

########################################
# SONARQUBE
########################################

variable "sonarqube_image" {
  description = "SonarQube Docker image"
  type        = string
  default     = "sonarqube:26.8.0.126808-community"
}

variable "sonarqube_container" {
  description = "SonarQube Docker container name"
  type        = string
  default     = "sonarqube"
}

variable "sonarqube_port" {
  description = "SonarQube application port"
  type        = number
  default     = 9000
}

variable "sonarqube_mount_path" {
  description = "Mount path for SonarQube persistent data"
  type        = string
  default     = "/opt/sonarqube-data"
}

variable "sonarqube_uid" {
  description = "UID used by the SonarQube container"
  type        = number
  default     = 1000
}

variable "sonarqube_gid" {
  description = "GID used by the SonarQube container"
  type        = number
  default     = 1000
}

########################################
# POSTGRESQL
########################################

variable "postgres_image" {
  description = "PostgreSQL Docker image"
  type        = string
  default     = "postgres:17"
}

variable "postgres_container" {
  description = "PostgreSQL Docker container name"
  type        = string
  default     = "postgres"
}

variable "postgres_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "sonar"
}

variable "postgres_db" {
  description = "PostgreSQL database name"
  type        = string
  default     = "sonar"
}

variable "postgres_port" {
  description = "PostgreSQL port"
  type        = number
  default     = 5432
}

variable "postgres_mount_path" {
  description = "Mount path for PostgreSQL persistent data"
  type        = string
  default     = "/var/lib/postgresql-data"
}

variable "postgres_uid" {
  description = "UID used by the PostgreSQL container"
  type        = number
  default     = 999
}

variable "postgres_gid" {
  description = "GID used by the PostgreSQL container"
  type        = number
  default     = 999
}

########################################
# DOCKER
########################################

variable "docker_network" {
  description = "Docker network used by SonarQube and PostgreSQL"
  type        = string
  default     = "sonarqube"
}

########################################
# AWS SECRETS MANAGER
########################################

variable "secret_name" {
  description = "AWS Secrets Manager secret name for PostgreSQL"
  type        = string
  default     = "speshway/test/sonarqube/postgres"
}

variable "secret_description" {
  description = "Description of the PostgreSQL Secrets Manager secret"
  type        = string
  default     = "PostgreSQL credentials for SonarQube"
}

variable "postgres_password_file" {
  description = "Local file containing the PostgreSQL password"
  type        = string
  default     = "/etc/sonarqube/postgres-password"
}

########################################
# DOCKER COMPOSE
########################################

variable "compose_directory" {
  description = "Directory containing SonarQube Docker Compose files"
  type        = string
  default     = "/opt/sonarqube"
}

variable "compose_file" {
  description = "Docker Compose file path"
  type        = string
  default     = "/opt/sonarqube/docker-compose.yml"
}

variable "compose_env_file" {
  description = "Docker Compose environment file path"
  type        = string
  default     = "/opt/sonarqube/.env"
}

########################################
# POSTGRES HEALTH CHECK
########################################

variable "postgres_health_interval" {
  description = "PostgreSQL Docker health check interval"
  type        = string
  default     = "10s"
}

variable "postgres_health_timeout" {
  description = "PostgreSQL Docker health check timeout"
  type        = string
  default     = "5s"
}

variable "postgres_health_retries" {
  description = "Number of PostgreSQL health check retries"
  type        = number
  default     = 10
}

variable "postgres_health_start_period" {
  description = "PostgreSQL health check startup period"
  type        = string
  default     = "20s"
}

variable "container_start_wait" {
  description = "Seconds to wait after starting Docker containers"
  type        = number
  default     = 30
}

########################################
# SONARQUBE KERNEL SETTINGS
########################################

variable "vm_max_map_count" {
  description = "Linux vm.max_map_count required by SonarQube"
  type        = number
  default     = 524288
}

variable "fs_file_max" {
  description = "Linux maximum number of open files"
  type        = number
  default     = 131072
}

########################################
# MONITORING
########################################

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

########################################
# TAGS
########################################

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
}
