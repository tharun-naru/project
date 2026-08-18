variable "project_name" {
  description = "Project name"
  type        = string

  validation {
    condition     = length(trim(var.project_name, " ")) > 0
    error_message = "Project name cannot be empty."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition = contains(
      ["dev", "test", "stage", "prod"],
      var.environment
    )
    error_message = "Environment must be one of: dev, test, stage or prod."
  }
}


variable "buckets" {

  description = "S3 bucket configuration"

  type = map(object({

    ########################################
    # Bucket
    ########################################

    bucket_name = optional(string)

    versioning = bool

    kms_key_arn = string

    force_destroy = optional(bool, false)

    ########################################
    # Lifecycle
    ########################################

    lifecycle = optional(object({

      enabled = bool

      noncurrent_version_days = optional(number, 90)

      abort_incomplete_upload_days = optional(number, 7)

      expiration_days = optional(number)

      transition = optional(object({

        days = number

        storage_class = string

      }))

    }), {

      enabled = true

      noncurrent_version_days = 90

      abort_incomplete_upload_days = 7

    })

    ########################################
    # Additional Policy Statements
    ########################################

    #bucket_policy_statements = optional(list(any), [])

  }))

  default = {}

}
