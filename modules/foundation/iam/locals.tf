locals {

  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(

    var.common_tags,

    {

      Project = var.project_name

      Environment = var.environment

      ManagedBy = "Terraform"

      Module = "IAM"

    }

  )

}
############################################
#Managed Policy Attachments
############################################
locals {
  managed_policy_attachments = {
    for attachment in flatten([

      for role_key, role in var.iam_roles : [

        for policy_arn in role.managed_policy_arns : {

          key = "${role_key}-${md5(policy_arn)}"

          role_key = role_key

          policy_arn = policy_arn

        }

      ]

    ]) :

    attachment.key => attachment
  }
}
############################################
#Custom Policy Definitions
#######################################
locals {
  custom_policies = {
    for policy_name, policy in var.iam_policies :
    policy_name => {
      policy_name = policy_name
      description = policy.description
      statements  = policy.statements
    }
  }

  custom_policy_attachments = {
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
}
