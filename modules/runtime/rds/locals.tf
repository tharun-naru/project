locals {

  name_prefix = "${var.project_name}-${var.environment}"

  db_identifier = "${local.name_prefix}-${var.identifier}"

  common_tags = merge(

    var.common_tags,

    {

      Module = "RDS"

    }

  )

}
