############################################
#IAM Roles
############################################
data "aws_iam_policy_document" "role_trust" {
  for_each = var.iam_roles
  ##########################################
  #AWS Service Trust
  ##########################################
  dynamic "statement" {
    for_each = length(each.value.trusted_services) > 0 ? [1] : []

    content {

      sid = "AllowAWSServiceAssumeRole"

      effect = "Allow"

      actions = [

        "sts:AssumeRole"

      ]

      principals {

        type = "Service"

        identifiers = each.value.trusted_services

      }

    }
  }
  ##########################################
  #IAM Role Trust
  ##########################################
  dynamic "statement" {
    for_each = length(each.value.trusted_role_arns) > 0 ? [1] : []

    content {

      sid = "AllowIAMRoleAssumeRole"

      effect = "Allow"

      actions = [

        "sts:AssumeRole"

      ]

      principals {

        type = "AWS"

        identifiers = each.value.trusted_role_arns

      }

    }
  }
}
############################################
#Create IAM Roles
############################################
resource "aws_iam_role" "this" {
  for_each           = var.iam_roles
  name               = each.value.name
  description        = each.value.description
  assume_role_policy = data.aws_iam_policy_document.role_trust[each.key].json
  tags = merge(
    local.common_tags,

    each.value.tags,

    {

      Name = each.value.name

    }
  )
}
