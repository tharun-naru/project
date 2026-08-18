resource "aws_db_parameter_group" "this" {

  name = "${local.db_identifier}-parameter-group"

  family = var.parameter_group_family

  description = "Parameter Group for ${local.db_identifier}"

  dynamic "parameter" {

    for_each = var.parameters

    content {

      name = parameter.key

      value = parameter.value.value

      apply_method = lookup(
        parameter.value,
        "apply_method",
        "immediate"
      )

    }

  }

  tags = merge(

    local.common_tags,

    {

      Name = "${local.db_identifier}-parameter-group"

    }

  )

}
