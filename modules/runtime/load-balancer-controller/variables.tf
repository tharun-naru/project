############################################
# Project
############################################

variable "project_name" {

  description = "Project name"

  type = string

}

variable "environment" {

  description = "Environment name"

  type = string

}

############################################
# Common Tags
############################################

variable "common_tags" {

  description = "Common resource tags"

  type = map(string)

  default = {}

}

############################################
# EKS
############################################

variable "cluster_name" {

  description = "EKS cluster name"

  type = string

}

variable "vpc_id" {

  description = "VPC ID where EKS is deployed"

  type = string

}

############################################
# IRSA
############################################

variable "irsa_role_arn" {

  description = "Existing IRSA role ARN for AWS Load Balancer Controller"

  type = string

}

############################################
# Kubernetes
############################################

variable "namespace" {

  description = "Kubernetes namespace for AWS Load Balancer Controller"

  type = string

  default = "kube-system"

}

variable "service_account_name" {

  description = "Kubernetes service account name"

  type = string

  default = "aws-load-balancer-controller"

}
############################################
# Helm
############################################

variable "helm_repository" {

  description = "AWS EKS Helm repository"

  type = string

  default = "https://aws.github.io/eks-charts"

}

variable "chart_name" {

  description = "AWS Load Balancer Controller Helm chart"

  type = string

  default = "aws-load-balancer-controller"

}

variable "chart_version" {

  description = "AWS Load Balancer Controller chart version"

  type = string

}

variable "create_namespace" {

  description = "Whether Terraform should create the Kubernetes namespace"

  type = bool

  default = false

}
