locals {
  name_prefix = "${var.environment}-monitoring"

  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Component   = "Monitoring"
  }
}
