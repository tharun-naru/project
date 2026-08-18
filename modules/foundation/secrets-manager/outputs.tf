output "secret_arns" {

  description = "ARNs of Secrets"

  value = {

    for key, secret in aws_secretsmanager_secret.this :

    key => secret.arn

  }

}

output "secret_names" {

  description = "Names of Secrets"

  value = {

    for key, secret in aws_secretsmanager_secret.this :

    key => secret.name

  }

}

output "secret_ids" {

  description = "IDs of Secrets"

  value = {

    for key, secret in aws_secretsmanager_secret.this :

    key => secret.id

  }

}

