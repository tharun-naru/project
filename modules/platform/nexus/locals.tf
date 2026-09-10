locals {
  nexus_name = "${var.project_name}-${var.environment}-nexus"

  nexus_tags = merge(
    var.common_tags,
    {
      Name    = local.nexus_name
      Service = "Nexus"
    }
  )
}
