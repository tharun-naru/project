############################################

# IAM Role Outputs

############################################

output "role_arns" {

  description = "ARNs of all IAM roles created by the module"

  value = {


    for key, role in aws_iam_role.this :

    key => role.arn


  }

}

output "role_names" {

  description = "Names of all IAM roles created by the module"

  value = {


    for key, role in aws_iam_role.this :

    key => role.name


  }

}

output "role_ids" {

  description = "Unique IDs of all IAM roles created by the module"

  value = {


    for key, role in aws_iam_role.this :

    key => role.unique_id


  }

}

############################################

# IAM Instance Profile Outputs

############################################

output "instance_profile_arns" {

  description = "ARNs of all IAM instance profiles created by the module"

  value = {


    for key, profile in aws_iam_instance_profile.this :

    key => profile.arn


  }

}

output "instance_profile_names" {

  description = "Names of all IAM instance profiles created by the module"

  value = {


    for key, profile in aws_iam_instance_profile.this :

    key => profile.name


  }

}

output "instance_profile_ids" {

  description = "IDs of all IAM instance profiles created by the module"

  value = {


    for key, profile in aws_iam_instance_profile.this :

    key => profile.id


  }

}
output "policy_arns" {
  description = "ARNs of all customer-managed IAM policies"

  value = {
    for key, policy in aws_iam_policy.custom :
    key => policy.arn
  }
}
