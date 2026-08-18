############################################
# ECR Repository Names
############################################

output "repository_names" {

  description = "Names of ECR repositories"

  value = {

    for key, repository in aws_ecr_repository.ecr :

    key => repository.name

  }

}

############################################
# ECR Repository ARNs
############################################

output "repository_arns" {

  description = "ARNs of ECR repositories"

  value = {

    for key, repository in aws_ecr_repository.ecr :

    key => repository.arn

  }

}

############################################
# ECR Repository URLs
############################################

output "repository_urls" {

  description = "Repository URLs used for image push and pull"

  value = {

    for key, repository in aws_ecr_repository.ecr :

    key => repository.repository_url

  }

}

############################################
# ECR Registry ID
############################################

output "registry_ids" {

  description = "Registry IDs of ECR repositories"

  value = {

    for key, repository in aws_ecr_repository.ecr :

    key => repository.registry_id

  }

}
