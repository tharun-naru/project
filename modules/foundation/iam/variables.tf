############################################
#Project Information
############################################
variable "project_name" {
  description = "Project name"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}
############################################
#Common Tags
############################################
variable "common_tags" {
  description = "Common tags applied to IAM resources"
  type        = map(string)
  default     = {}
}
############################################
#Generic IAM Roles
############################################
variable "iam_roles" {
  description = "IAM roles and their configurations"
  type = map(object({
    name = string

    description = optional(
      string,
      null
    )

    ##########################################
    # Trust Configuration
    ##########################################

    trusted_services = optional(
      list(string),
      []
    )

    trusted_role_arns = optional(
      list(string),
      []
    )

    ##########################################
    # AWS Managed Policies
    ##########################################

    managed_policy_arns = optional(
      list(string),
      []
    )

    ##########################################
    # Customer Managed Policies
    ##########################################

    policy_names = optional(
      list(string),
      []
    )

    ##########################################
    # EC2 Instance Profile
    ##########################################

    create_instance_profile = optional(
      bool,
      false
    )

    ##########################################
    # Role-Specific Tags
    ##########################################

    tags = optional(
      map(string),
      {}
    )
  }))
  default = {}
}
variable "iam_policies" {
  description = "Reusable customer-managed IAM policies"

  type = map(object({
    description = optional(string, null)

    statements = list(object({
      sid = optional(string)

      actions = list(string)

      resources = list(string)

      effect = optional(string, "Allow")

      conditions = optional(map(object({
        test     = string
        variable = string
        values   = list(string)
      })), {})
    }))
  }))

  default = {}
}

