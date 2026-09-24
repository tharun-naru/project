resource "aws_launch_template" "this" {

  for_each = var.launch_templates

  name_prefix = "${local.name_prefix}-${each.key}-"

  user_data = each.value.user_data != null ? base64encode(each.value.user_data) : null

  block_device_mappings {

    device_name = "/dev/xvda"

    ebs {

      volume_size = each.value.root_volume_size

      volume_type = each.value.root_volume_type

      encrypted = each.value.encrypted

      delete_on_termination = each.value.delete_on_termination

    }

  }

  vpc_security_group_ids = concat(

    var.create_additional_security_group

      ? [aws_security_group.additional[0].id]

      : [],

    each.value.additional_security_group_ids

  )

  tag_specifications {

    resource_type = "instance"

    tags = merge(

      local.common_tags,

      {

        Name = "${local.name_prefix}-${each.key}-node"

      }

    )

  }

}
