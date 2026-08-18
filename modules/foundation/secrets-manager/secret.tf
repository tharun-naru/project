############################################
# Secrets Manager Secret
############################################
resource "aws_secretsmanager_secret" "this" {

  for_each = var.secrets

  name = "${local.name_prefix}-${each.key}"

  kms_key_id = each.value.kms_key_arn

  description = each.value.description

  recovery_window_in_days = var.recovery_window_in_days

  lifecycle {

  ignore_changes = [

    tags["LastRotated"]

  ]

}

  tags = merge(

    local.common_tags,

    {

      name = "${local.name_prefix}-${each.key}"

    }

  )

}
############################################
# Secret Value / Version
############################################

resource "aws_secretsmanager_secret_version" "this" {

  for_each = {

    for key, value in var.secrets :

    key => value

    if value.create_version

  }

  secret_id = aws_secretsmanager_secret.this[each.key].id

  secret_string = each.value.secret_string

}

############################################
# Secret Rotation
############################################

resource "aws_secretsmanager_secret_rotation" "this" {

  for_each = {

    for key, value in var.secrets :

    key => value

    if value.enable_rotation

  }

  secret_id = aws_secretsmanager_secret.this[each.key].id

  rotation_lambda_arn = each.value.rotation_lambda_arn

  rotation_rules {

    automatically_after_days = each.value.rotation_days

  }

}
