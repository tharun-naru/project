############################################
# EKS Inputs (from parent)
############################################

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  type        = string
}

variable "node_role_arn" {
  description = "EKS Node Role ARN"
  type        = string
}

variable "common_tags" {
  description = "Common Tags"
  type        = map(string)
}
variable "karpenter_node_classes" {
  description = "Karpenter EC2 Node Classes"
  type = map(object({
    ami_family = string
    ami_alias = string
  }))
}

variable "controller_role_arn" {

  description = "IAM Role ARN for the Karpenter controller"

  type = string

}
variable "karpenter_version" {
  description = "Karpenter Helm chart version"
  type        = string
  default     = "1.14.0"
}


variable "deploy_karpenter_manifests" {

  description = "Deploy Karpenter NodeClass and NodePool"

  type    = bool

  default = false

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

    consolidate_after    = optional(string, "30s")
  }))
  default = {}
}
