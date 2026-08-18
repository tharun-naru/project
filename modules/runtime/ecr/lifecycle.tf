############################################
# ECR Lifecycle Policies
############################################

resource "aws_ecr_lifecycle_policy" "lpolicy" {

  for_each = {

    for key, repository in var.repositories :

    key => repository

    if repository.lifecycle.enabled

  }

  repository = aws_ecr_repository.ecr[each.key].name

  policy = jsonencode({

    rules = [

      {

        rulePriority = 1

        description = "Expire untagged images"

        selection = {

          tagStatus = "untagged"

          countType = "sinceImagePushed"

          countUnit = "days"

          countNumber = each.value.lifecycle.untagged_image_days

        }

        action = {

          type = "expire"

        }

      },

      {

        rulePriority = 2

        description = "Retain a limited number of tagged images"

        selection = {

          tagStatus = "any"

          countType = "imageCountMoreThan"

          countNumber = each.value.lifecycle.max_image_count

        }

        action = {

          type = "expire"

        }

      }

    ]

  })

}
