############################################
# Local Values
############################################

locals {

  ##########################################
  # Name Prefix
  ##########################################

  name_prefix = "${var.project_name}-${var.environment}"

  ##########################################
  # Controller Name
  ##########################################

  controller_name = "aws-load-balancer-controller"

  ##########################################
  # Common Tags
  ##########################################

  common_tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Module      = "Load Balancer Controller"
    }
  )

}
