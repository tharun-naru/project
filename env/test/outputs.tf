############################################
# Networking Outputs
############################################

output "vpc_id" {

  description = "ID of the VPC"

  value = module.networking.vpc_id

}

output "public_subnet_ids" {

  description = "IDs of the public subnets"

  value = module.networking.public_subnet_ids

}

output "private_subnet_ids" {

  description = "IDs of the private subnets"

  value = module.networking.private_subnet_ids

}

output "nat_gateway_ids" {

  description = "IDs of the NAT Gateways"

  value = module.networking.nat_gateway_ids

}

output "public_route_table_id" {

  description = "ID of the public route table"

  value = module.networking.public_route_table_id

}

output "private_route_table_ids" {

  description = "IDs of the private route tables"

  value = module.networking.private_route_table_ids

}

output "igw_id" {

  description = "ID of the Internet Gateway"

  value = module.networking.igw_id

}

output "allocation_ids" {

  description = "Elastic IP allocation IDs used by NAT Gateways"

  value = module.networking.allocation_ids

}


############################################
# KMS Outputs
############################################

output "kms_key_arns" {

  description = "ARNs of KMS keys"

  value = module.kms.kms_key_arns

}

output "kms_key_ids" {

  description = "IDs of KMS keys"

  value = module.kms.kms_key_ids

}

output "kms_aliases" {

  description = "Aliases of KMS keys"

  value = module.kms.kms_aliases

}
############################################
# ECR Outputs
############################################

output "ecr_repository_arns" {

  description = "ARNs of all ECR repositories"

  value = module.ecr.repository_arns

}

output "ecr_repository_names" {

  description = "Names of all ECR repositories"

  value = module.ecr.repository_names

}

output "ecr_repository_urls" {

  description = "URLs of all ECR repositories"

  value = module.ecr.repository_urls

}
############################################
# EKS Outputs
############################################

output "eks_cluster_name" {

  description = "EKS Cluster Name"

  value = module.eks.cluster_name

}

output "eks_cluster_arn" {

  description = "EKS Cluster ARN"

  value = module.eks.cluster_arn

}

output "eks_cluster_endpoint" {

  description = "EKS Cluster Endpoint"

  value = module.eks.cluster_endpoint

}

output "eks_cluster_version" {

  description = "Kubernetes Version"

  value = module.eks.cluster_version

}

output "eks_cluster_security_group_id" {

  description = "Cluster Security Group"

  value = module.eks.cluster_security_group_id

}

output "eks_oidc_provider_arn" {

  description = "OIDC Provider ARN"

  value = module.eks.oidc_provider_arn

}

output "eks_node_group_arns" {

  description = "Managed Node Groups"

  value = module.eks.node_group_arns

}
############################################
# RDS
############################################

output "rds_endpoint" {
  description = "RDS endpoint"

  value = module.rds.db_instance_endpoint
}

output "rds_port" {
  description = "RDS port"

  value = module.rds.db_instance_port
}

output "rds_database_name" {
  description = "RDS database name"

  value = module.rds.db_instance_name
}

output "rds_master_user_secret_arn" {
  description = "AWS Secrets Manager ARN containing the RDS master credentials"

  value = module.rds.master_user_secret_arn
}
# =========================================================
# Jenkins
# =========================================================

output "jenkins_instance_id" {
  description = "Jenkins EC2 instance ID"
  value       = module.jenkins.instance_id
}

output "jenkins_private_ip" {
  description = "Jenkins private IP"
  value       = module.jenkins.private_ip
}

output "jenkins_security_group_id" {
  description = "Jenkins security group ID"
  value       = module.jenkins.security_group_id
}

output "jenkins_data_volume_id" {
  description = "Jenkins persistent EBS volume ID"
  value       = module.jenkins.data_volume_id
}

output "jenkins_iam_policy_arn" {
  description = "Jenkins service-specific IAM policy ARN"
  value       = module.jenkins.iam_policy_arn
}


# =========================================================
# Nexus
# =========================================================

output "nexus_instance_id" {
  description = "Nexus EC2 instance ID"
  value       = module.nexus.instance_id
}

output "nexus_private_ip" {
  description = "Nexus private IP"
  value       = module.nexus.private_ip
}

output "nexus_security_group_id" {
  description = "Nexus security group ID"
  value       = module.nexus.security_group_id
}

output "nexus_data_volume_id" {
  description = "Nexus persistent EBS volume ID"
  value       = module.nexus.data_volume_id
}

output "nexus_iam_policy_arn" {
  description = "Nexus service-specific IAM policy ARN"
  value       = module.nexus.iam_policy_arn
}


# =========================================================
# SonarQube
# =========================================================

output "sonarqube_instance_id" {
  description = "SonarQube EC2 instance ID"
  value       = module.sonarqube.instance_id
}

output "sonarqube_private_ip" {
  description = "SonarQube private IP"
  value       = module.sonarqube.private_ip
}

output "sonarqube_security_group_id" {
  description = "SonarQube security group ID"
  value       = module.sonarqube.security_group_id
}

output "sonarqube_data_volume_ids" {
  description = "Persistent EBS volume IDs for SonarQube and PostgreSQL"
  value       = module.sonarqube.data_volume_ids
}

output "sonarqube_iam_policy_arn" {
  description = "SonarQube service-specific IAM policy ARN"
  value       = module.sonarqube.iam_policy_arn
}
