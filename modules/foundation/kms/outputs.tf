output "kms_key_arns" {

  description = "ARNs of all KMS Keys"

  value = {

    for key, kms in aws_kms_key.this :

    key => kms.arn

  }

}

output "kms_key_ids" {

  description = "IDs of all KMS Keys"

  value = {

    for key, kms in aws_kms_key.this :

    key => kms.id

  }

}

output "kms_aliases" {

  description = "Aliases of all KMS Keys"

  value = {

    for key, alias in aws_kms_alias.this :

    key => alias.name

  }

}

