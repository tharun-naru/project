############################################
# KMS Key Policy
############################################

data "aws_iam_policy_document" "this" {

  for_each = var.kms_keys

  ##########################################
  # Root Account
  ##########################################

  statement {

    sid = "EnableRootPermissions"

    effect = "Allow"

    principals {

      type = "AWS"

      identifiers = [
        "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
      ]

    }

    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]

  }

  ##########################################
  # KMS Administrators
  ##########################################

  dynamic "statement" {

    for_each = length(each.value.administrators) > 0 ? [1] : []

    content {

      sid = "KMSAdministrators"

      effect = "Allow"

      principals {

        type = "AWS"

        identifiers = each.value.administrators

      }

      actions = [
        "kms:*"
      ]

      resources = [
        "*"
      ]

    }

  }

  ##########################################
  # KMS Users
  ##########################################

  dynamic "statement" {

    for_each = length(each.value.users) > 0 ? [1] : []

    content {

      sid = "KMSUsers"

      effect = "Allow"

      principals {

        type = "AWS"

        identifiers = each.value.users

      }

      actions = [

        "kms:Encrypt",

        "kms:Decrypt",

        "kms:ReEncrypt*",

        "kms:GenerateDataKey",

        "kms:GenerateDataKeyWithoutPlaintext",

        "kms:DescribeKey"

      ]

      resources = [
        "*"
      ]

    }

  }

  ##########################################
  # Read Only Users
  ##########################################

  dynamic "statement" {

    for_each = length(each.value.readonly_users) > 0 ? [1] : []

    content {

      sid = "KMSReadOnly"

      effect = "Allow"

      principals {

        type = "AWS"

        identifiers = each.value.readonly_users

      }

      actions = [

        "kms:DescribeKey",

        "kms:GetKeyPolicy",

        "kms:ListResourceTags"

      ]

      resources = [
        "*"
      ]

    }

  }

}
