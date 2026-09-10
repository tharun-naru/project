############################################
# Project Information
############################################

variable "project_name" {

  description = "Project name"

  type = string

}

variable "environment" {

  description = "Environment name"

  type = string

}

variable "common_tags" {

  description = "Common tags"

  type = map(string)

  default = {}

}

variable "region" {
  type = string
}
############################################
# Networking
############################################

variable "vpc_id" {

  description = "VPC ID where EKS will be deployed"

  type = string

}

variable "private_subnet_ids" {

  description = "Private subnet IDs for EKS"

  type = list(string)

}

############################################
# EKS IAM
############################################

variable "cluster_role_arn" {

  description = "IAM role ARN for the EKS control plane"

  type = string

}

variable "node_role_arn" {

  description = "IAM role ARN for EKS managed node groups"

  type = string

}
############################################
# EKS Access Entries
############################################
variable "eks_access_entries" {
  description = "EKS access entries and their associated policies"
  type = map(object({
    principal_arn = string

    policy_arn = optional(
      string,
      "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    )

    access_scope = optional(object({
      type       = string
      namespaces = optional(list(string), [])
    }), {
      type       = "cluster"
      namespaces = []
    })

    type = optional(string, "STANDARD")
  }))

  default = {}
}
############################################
# EKS Cluster
############################################

variable "cluster_name" {

  description = "Optional EKS cluster name"

  type = string

  default = null

}

variable "cluster_version" {

  description = "Kubernetes version"

  type = string

}

variable "endpoint_private_access" {

  description = "Enable private EKS API endpoint access"

  type = bool

  default = true

}

variable "endpoint_public_access" {

  description = "Enable public EKS API endpoint access"

  type = bool

  default = false

}

variable "public_access_cidrs" {

  description = "CIDRs allowed to access the public EKS API endpoint"

  type = list(string)

  default = []

}

############################################
# EKS Encryption
############################################

variable "kms_key_arn" {

  description = "KMS key ARN for Kubernetes secret encryption"

  type = string

  default = null

}

############################################
# EKS Logging
############################################

variable "cluster_log_types" {

  description = "EKS Control Plane Log Types"

  type = list(string)

  default = [

    "api",

    "audit",

    "authenticator",

    "controllerManager",

    "scheduler"

  ]

}

variable "cluster_log_retention_in_days" {

  description = "CloudWatch Log Retention"

  type = number

  default = 30

}

variable "cluster_log_kms_key_arn" {

  description = "KMS Key ARN for CloudWatch Log Encryption"

  type = string

  default = null

}

############################################
# Managed Node Groups
############################################

variable "node_groups" {

  description = "Dynamic EKS managed node groups"

  type = map(object({

    instance_types = list(string)

    capacity_type = optional(string, "ON_DEMAND")

    min_size = number

    max_size = number

    desired_size = number

    disk_size = optional(number, 50)

    labels = optional(map(string), {})

    taints = optional(map(object({

      key = string

      value = optional(string)

      effect = string

    })), {})

    use_launch_template = optional(bool, false)

  }))

  default = {}

}

############################################
# Launch Templates
############################################

variable "launch_templates" {

  description = "Optional launch-template configuration"

  type = map(object({

    root_volume_size = optional(number, 50)

    root_volume_type = optional(string, "gp3")

    delete_on_termination = optional(bool, true)

    encrypted = optional(bool, true)

    additional_security_group_ids = optional(list(string), [])

  }))

  default = {}

}

############################################
# Additional EKS Security Group
############################################

variable "create_additional_security_group" {

  description = "Create an additional security group for EKS nodes"

  type = bool

  default = false

}

variable "additional_security_group_ingress" {

  description = "Additional ingress rules"

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

variable "karpenter_discovery_tag" {
  description = "Karpenter discovery tag value"
  type        = string
  default     = null
}
############################################
# OIDC
############################################

variable "enable_oidc" {

  description = "Create EKS OIDC provider"

  type = bool

  default = true

}

############################################
# Generic IRSA
############################################

variable "irsa_roles" {

  description = "Optional generic IAM roles for Kubernetes service accounts"

  type = map(object({

    namespace = string

    service_account = string

    policy_arns = optional(list(string), [])

    policy_names = optional(list(string), [])
  }))

  default = {}

}

############################################
# EKS & Helm Add-ons
############################################

variable "addons" {

  description = "EKS managed add-ons and Helm add-ons"

  type = map(object({

    ##########################################
    # Common
    ##########################################

    type = string

    irsa_role = optional(string)

    ##########################################
    # EKS Managed Add-on
    ##########################################

    addon_version = optional(string)

    resolve_conflicts_on_create = optional(
      string,
      "OVERWRITE"
    )

    resolve_conflicts_on_update = optional(
      string,
      "OVERWRITE"
    )

    ##########################################
    # Helm
    ##########################################

    namespace = optional(string)

    repository = optional(string)

    chart = optional(string)

    version = optional(string)

    create_namespace = optional(
      bool,
      true
    )

    values = optional(
      any,
      {}
    )
    set = optional(
  map(string),
  {}
)

  }))

  default = {}

}
############################################
# Karpenter
############################################

variable "enable_karpenter" {

  description = "Enable the Karpenter child module"

  type = bool

  default = true

}
############################################
# Karpenter
############################################

variable "karpenter_node_classes" {
  description = "EC2 Node Classes"

  type = map(object({

    ami_family = string
    ami_alias = string

  }))

  default = {}
}

variable "karpenter_node_pools" {

  description = "Karpenter Node Pools"

  type = map(object({

    node_class = string

    instance_families = list(string)

    capacity_types = list(string)

    cpu_limit = string

    memory_limit = string

    consolidation_policy = string

    expire_after = string

  }))

  default = {}

}
variable "deploy_karpenter_manifests" {

  description = "Deploy Karpenter NodeClass and NodePool"

  type    = bool

  default = true

}
variable "karpenter_version" {
  description = "Karpenter Helm chart version"
  type        = string
  default     = "1.14.0"
}
