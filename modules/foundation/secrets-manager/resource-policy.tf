############################################
# Secrets Manager Resource Policy
############################################

data "aws_iam_policy_document" "this" {

  for_each = aws_secretsmanager_secret.this

  ##########################################
  # Root Account
  ##########################################

  statement {

    sid = "RootPermissions"

    effect = "Allow"

    principals {

      type = "AWS"

      identifiers = [

        "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"

      ]

    }

    actions = [

      "secretsmanager:*"

    ]

    resources = [

      each.value.arn

    ]

  }

  ##########################################
  # Secret Administrators
  ##########################################

  dynamic "statement" {

    for_each = length(var.secrets[each.key].administrators) > 0 ? [1] : []

    content {

      sid = "SecretAdministrators"

      effect = "Allow"

      principals {

        type = "AWS"

        identifiers = var.secrets[each.key].administrators

      }

      actions = [

        "secretsmanager:*"

      ]

      resources = [

        each.value.arn

      ]

    }

  }

  ##########################################
  # Secret Readers
  ##########################################

  dynamic "statement" {

    for_each = length(var.secrets[each.key].readers) > 0 ? [1] : []

    content {

      sid = "SecretReaders"

      effect = "Allow"

      principals {

        type = "AWS"

        identifiers = var.secrets[each.key].readers

      }

      actions = [

        "secretsmanager:GetSecretValue",

        "secretsmanager:DescribeSecret"

      ]

      resources = [

        each.value.arn

      ]

    }

  }

}

############################################
# Attach Resource Policy
############################################

resource "aws_secretsmanager_secret_policy" "this" {

  for_each = aws_secretsmanager_secret.this

  secret_arn = each.value.arn

  policy = data.aws_iam_policy_document.this[each.key].json

}

