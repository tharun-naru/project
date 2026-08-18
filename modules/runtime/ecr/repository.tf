############################################
# ECR Repositories
############################################

resource "aws_ecr_repository" "ecr" {

  for_each = var.repositories

  name = coalesce(

    each.value.repository_name,

    "${local.name_prefix}-${each.key}"

  )

  image_tag_mutability = each.value.image_tag_mutability

  force_delete = each.value.force_delete

  encryption_configuration {

    encryption_type = each.value.encryption_type

    kms_key = (

      each.value.encryption_type == "KMS"

      ? var.kms_key_arn

      : null

    )

  }

  tags = merge(

    local.common_tags,

    each.value.tags,

    {

      Name = coalesce(

        each.value.repository_name,

        "${local.name_prefix}-${each.key}"

      )

      Repository = each.key

    }

  )

}
