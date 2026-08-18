variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "enable_key_rotation" {
  type    = bool
  default = true
}


variable "kms_keys" {

  description = "KMS Keys Configuration"

  type = map(object({

    description = string

    alias = string

    administrators = optional(list(string), [])

    users          = optional(list(string), [])

    readonly_users = optional(list(string), [])

  }))

}
variable "deletion_window_in_days" {

  description = "Number of days before a KMS key is permanently deleted"

  type = number

  default = 30

  validation {

    condition = (
      var.deletion_window_in_days >= 7 &&
      var.deletion_window_in_days <= 30
    )

    error_message = "deletion_window_in_days must be between 7 and 30."

  }

}
