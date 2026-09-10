locals {
  alb_name = "${var.project_name}-${var.environment}-shared-alb"

  alb_tags = merge(
    var.common_tags,
    {
      Name    = local.alb_name
      Service = "Shared-ALB"
    }
  )
}
