output "cluster_version" {

  description = "EKS Kubernetes version"

  value = aws_eks_cluster.this.version

}
output "cluster_name" {

  value = aws_eks_cluster.this.name

}

output "cluster_arn" {

  value = aws_eks_cluster.this.arn

}

output "cluster_endpoint" {

  value = aws_eks_cluster.this.endpoint

}

output "cluster_certificate_authority_data" {

  value = aws_eks_cluster.this.certificate_authority[0].data

  sensitive = true

}

output "cluster_security_group_id" {

  value = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id

}

output "oidc_provider_arn" {

  value = try(

    aws_iam_openid_connect_provider.this[0].arn,

    null

  )

}

output "oidc_provider_url" {

  value = try(

    aws_iam_openid_connect_provider.this[0].url,

    null

  )

}

output "node_group_arns" {

  value = {

    for key, node_group in aws_eks_node_group.this :

    key => node_group.arn

  }

}

output "node_group_names" {

  value = {

    for key, node_group in aws_eks_node_group.this :

    key => node_group.node_group_name

  }

}

output "irsa_role_arns" {

  value = {

    for key, role in aws_iam_role.irsa :

    key => role.arn

  }

}

output "additional_security_group_id" {

  value = try(

    aws_security_group.additional[0].id,

    null

  )

}
output "karpenter_queue_name" {
  value = try(module.karpenter[0].interruption_queue_name, null)
}
output "karpenter_queue_arn" {
  value = try(module.karpenter[0].interruption_queue_arn, null)
}

output "karpenter_helm_release_name" {
  value = try(module.karpenter[0].helm_release_name, null)
}

output "karpenter_node_classes" {
  value = try(module.karpenter[0].node_classes, null)
}

output "karpenter_node_pools" {
  value = try(module.karpenter[0].node_pools, null)
}
