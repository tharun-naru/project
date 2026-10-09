############################################
# General Configuration
############################################

variable "name" {
  description = "Karpenter Helm release name"
  type        = string
  default     = "karpenter"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "common_tags" {
  description = "Common AWS resource tags"
  type        = map(string)
  default     = {}
}

############################################
# Karpenter Helm Configuration
############################################

variable "helm_repository" {
  description = "Karpenter OCI Helm repository"
  type        = string
  default     = "oci://public.ecr.aws/karpenter"
}

variable "chart_name" {
  description = "Karpenter Helm chart name"
  type        = string
  default     = "karpenter"
}

variable "karpenter_version" {
  description = "Karpenter Helm chart version"
  type        = string
  default     = "1.14.0"
}

variable "namespace" {
  description = "Karpenter Kubernetes namespace"
  type        = string
  default     = "karpenter"
}

variable "create_namespace" {
  description = "Create Karpenter namespace"
  type        = bool
  default     = true
}

variable "wait" {
  description = "Wait for Helm deployment"
  type        = bool
  default     = true
}

variable "timeout" {
  description = "Helm timeout in seconds"
  type        = number
  default     = 600
}

############################################
# Karpenter IAM Configuration
############################################

variable "controller_role_arn" {
  description = "IAM role ARN for Karpenter controller"
  type        = string
  default     = null
}

variable "node_role_name" {
  description = "IAM role name for Karpenter EC2 nodes"
  type        = string
}

############################################
# Service Account Configuration
############################################

variable "service_account_create" {
  description = "Create Karpenter service account"
  type        = bool
  default     = true
}

variable "service_account_name" {
  description = "Karpenter service account name"
  type        = string
  default     = "karpenter"
}

############################################
# Karpenter EC2NodeClass Configuration
############################################

variable "deploy_karpenter_manifests" {
  description = "Deploy Karpenter NodeClasses and NodePools"
  type        = bool
  default     = false
}

variable "karpenter_node_classes" {
  description = "Karpenter EC2NodeClass configurations"

  type = map(object({
    ami_family = string
    ami_alias  = string
  }))

  default = {}
}

variable "subnet_discovery_tags" {
  description = "Tags for selecting Karpenter subnets"
  type        = map(string)
}

variable "security_group_discovery_tags" {
  description = "Tags for selecting Karpenter security groups"
  type        = map(string)
}

variable "node_name_prefix" {
  description = "Prefix for Karpenter EC2 instance names"
  type        = string
}

variable "node_discovery_tags" {
  description = "Additional tags for Karpenter EC2 resources"
  type        = map(string)
  default     = {}
}

############################################
# Karpenter NodePool Configuration
############################################

variable "karpenter_node_pools" {
  description = "Karpenter NodePool configurations"

  type = map(object({

    node_class = string

    instance_families = list(string)

    capacity_types = list(string)

    architectures = optional(
      list(string),
      ["amd64"]
    )

    operating_systems = optional(
      list(string),
      ["linux"]
    )

    cpu_limit = string

    memory_limit = string

    consolidation_policy = string

    expire_after = string

    consolidate_after = optional(
      string,
      "30s"
    )

  }))

  default = {}
}

############################################
# Karpenter SQS Configuration
############################################

variable "interruption_queue_name" {
  description = "Optional custom SQS queue name"
  type        = string
  default     = null
}

variable "message_retention_seconds" {
  description = "SQS message retention period"
  type        = number
  default     = 300

  validation {
    condition = (
      var.message_retention_seconds >= 60 &&
      var.message_retention_seconds <= 1209600
    )

    error_message = "SQS retention must be between 60 and 1209600 seconds."
  }
}

variable "sqs_managed_sse_enabled" {
  description = "Enable SQS-managed encryption"
  type        = bool
  default     = true
}

variable "kms_master_key_id" {
  description = "Optional KMS key ID or ARN for SQS"
  type        = string
  default     = null
}
