############################################
# Project Information
############################################

variable "project_name" {

  description = "Project name"

  type = string

}

variable "environment" {

  description = "Deployment environment"

  type = string

}

############################################
# Common Tags
############################################

variable "common_tags" {

  description = "Common tags applied to ECR resources"

  type = map(string)

  default = {}

}

############################################
# ECR Repositories
############################################

variable "repositories" {

  description = "Configuration for ECR repositories"

  type = map(object({

    repository_name = optional(string)

    image_tag_mutability = optional(
      string,
      "IMMUTABLE"
    )

    force_delete = optional(
      bool,
      false
    )

    encryption_type = optional(
      string,
      "KMS"
    )

    kms_key_arn = optional(
      string,
      null
    )

    lifecycle = optional(object({

      enabled = optional(
        bool,
        true
      )

      max_image_count = optional(
        number,
        30
      )

      untagged_image_days = optional(
        number,
        14
      )

    }), {})


    tags = optional(
      map(string),
      {}
    )

  }))

  default = {}

  validation {

    condition = alltrue([

      for repository in values(var.repositories) :

      contains(

        [

          "MUTABLE",

          "IMMUTABLE"

        ],

        repository.image_tag_mutability

      )

    ])

    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."

  }

  validation {

    condition = alltrue([

      for repository in values(var.repositories) :

      contains(

        [

          "AES256",

          "KMS"

        ],

        repository.encryption_type

      )

    ])

    error_message = "encryption_type must be AES256 or KMS."

  }

}
variable "kms_key_arn" {

  description = "KMS key ARN used for ECR repository encryption"

  type = string

  default = null

}
