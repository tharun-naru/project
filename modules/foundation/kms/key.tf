resource "aws_kms_key" "this" {

  for_each = var.kms_keys

  description = "${local.name_prefix} ${each.value.description} KMS Key"

  deletion_window_in_days = var.deletion_window_in_days

  enable_key_rotation = var.enable_key_rotation

  policy = data.aws_iam_policy_document.this[each.key].json

  tags = merge(

    local.common_tags,

    {

      Name    = "${local.name_prefix}-${each.key}-kms"

      Service = each.value.description

    }

  )

}

