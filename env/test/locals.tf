############################################
# Common Tags
############################################

locals {

  common_tags = {

    Project = var.project_name

    Environment = var.environment

    ManagedBy = "Terraform"

  }

}

############################################
# IAM Configuration
############################################

#locals{
#iam_roles = {

#  compute_ec2 = {
#    name = "${var.project_name}-${var.environment}-compute-role"
#    description = "IAM role for Compute EC2 instances"
#    trusted_services = [
#      "ec2.amazonaws.com"
#    ]
#    managed_policy_arns = [
#      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
#      "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
#    ]
#    custom_policy_documents = {}
#    create_instance_profile = true

#}

#}
#} 
############################################
# KMS Keys
############################################

#locals {

# kms_keys = {

#  s3 = {
#    description = "S3"
#    alias = "alias/${var.project_name}-${var.environment}-s3"
#    administrators = [
#      module.iam.role_arns["compute_ec2"]
#    ]
#    users = [
#       module.iam.role_arns["compute_ec2"]
#     ]
#   }

#  secrets = {
#    description = "Secrets Manager"
#     alias = "alias/${var.project_name}-${var.environment}-secrets"
#    administrators = [
#      module.iam.role_arns["compute_ec2"]
#    ]
#    users = [
#      module.iam.role_arns["compute_ec2"]
#     ]
#  }

#}
#}

############################################
# S3 Buckets
############################################

#locals {

# s3_buckets = {

#   artifacts = {

#      versioning = true

#     kms_key_arn = module.kms.kms_key_arns["s3"]

#     force_destroy = false

#     lifecycle = {

#       enabled = true

#       noncurrent_version_days = 90

#        abort_incomplete_upload_days = 7

#      }

#    }

#  }

#}

############################################
# Secrets Manager
############################################

#locals {

# secrets = {
#   application = {
#     description = "Application secret"
#     kms_key_arn = module.kms.kms_key_arns["secrets"]
#     create_version = false

#     enable_rotation = false
#     administrators = [
#          module.iam.role_arns["compute_ec2"]
#     ]
#
#     readers = [
#          module.iam.role_arns["compute_ec2"]
#     ]
#
#   }
#
# }

#}
