data "aws_iam_policy_document" "irsa_assume_role" {

  for_each = var.enable_oidc ? var.irsa_roles : {}

  statement {

    effect = "Allow"

    actions = [

      "sts:AssumeRoleWithWebIdentity"

    ]

    principals {

      type = "Federated"

      identifiers = [

        aws_iam_openid_connect_provider.this[0].arn

      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(

        aws_iam_openid_connect_provider.this[0].url,

        "https://",

        ""

      )}:sub"

      values = [

        "system:serviceaccount:${each.value.namespace}:${each.value.service_account}"

      ]

    }

  }

}

resource "aws_iam_role" "irsa" {

  for_each = var.enable_oidc ? var.irsa_roles : {}

  name = "${local.name_prefix}-${each.key}-irsa-role"

  assume_role_policy = data.aws_iam_policy_document.irsa_assume_role[each.key].json

  tags = merge(

    local.common_tags,

    {

      Name = "${local.name_prefix}-${each.key}-irsa-role"

    }

  )

}

resource "aws_iam_role_policy_attachment" "irsa" {
  for_each = var.enable_oidc ? {
    for item in flatten([
      for role_key, role in var.irsa_roles : [
        for policy_index, policy_arn in role.policy_arns : {
          key        = "${role_key}-${policy_index}"
          role_key   = role_key
          policy_arn = policy_arn
        }
      ]
    ]) :
    item.key => item
  } : {}

  role       = aws_iam_role.irsa[each.value.role_key].name
  policy_arn = each.value.policy_arn
}
