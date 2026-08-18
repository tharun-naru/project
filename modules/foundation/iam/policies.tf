############################################
#Generic AWS Managed Policy Attachments
############################################
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = local.managed_policy_attachments
  role = aws_iam_role.this[
    each.value.role_key
  ].name
  policy_arn = each.value.policy_arn
}
############################################
#Generic Custom Managed Policies
############################################
resource "aws_iam_policy" "custom" {
  for_each = local.custom_policies

  name = "${local.name_prefix}-${each.key}"

  description = each.value.description != null ? each.value.description : "Customer managed IAM policy ${each.key}"

  policy = jsonencode({
  Version = "2012-10-17"

  Statement = [
    for statement in each.value.statements : merge(
      {
        Effect   = statement.effect
        Action   = statement.actions
        Resource = statement.resources
      },

      statement.sid != null ? {
        Sid = statement.sid
      } : {},

      length(statement.conditions) > 0 ? {
        Condition = {
          for _, condition in statement.conditions :
          condition.test => {
            condition.variable = condition.values
          }
        }
      } : {}
    )
  ]
})

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-${each.key}"
    }
  )
}
############################################
#Attach Custom Managed Policies
############################################
resource "aws_iam_role_policy_attachment" "custom" {
  for_each = {
    for attachment in flatten([
      for role_key, role in var.iam_roles : [
        for policy_name in role.policy_names : {
          key         = "${role_key}-${policy_name}"
          role_key    = role_key
          policy_name = policy_name
        }
      ]
    ]) :
    attachment.key => attachment
  }

  role = aws_iam_role.this[each.value.role_key].name

  policy_arn = aws_iam_policy.custom[
    each.value.policy_name
  ].arn
}
