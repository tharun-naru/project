variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
}


variable "recovery_window_in_days" {
  description = "Recovery window before deleting secrets"
  type        = number
  default     = 30

  validation {
    condition     = var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30
    error_message = "Recovery window must be between 7 and 30 days."
  }
}

variable "secrets" {

  description = "Secrets configuration"

  type = map(object({

    description = string

    kms_key_arn = string

    create_version = optional(bool, false)

    secret_string = optional(string)

    enable_rotation = optional(bool, false)

    rotation_lambda_arn = optional(string)

    rotation_days = optional(number)

    administrators = optional(list(string), [])

    readers = optional(list(string), [])

  }))

  default = {}

  validation {

  condition = alltrue([

    for secret in values(var.secrets) :

    !secret.enable_rotation || (

      secret.rotation_lambda_arn != null &&

      secret.rotation_days != null

    )

  ])
  error_message = "Rotation-enabled secrets must provide rotation_lambda_arn and rotation_days."

}
}
