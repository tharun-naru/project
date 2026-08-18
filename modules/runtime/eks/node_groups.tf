resource "aws_eks_node_group" "this" {

  for_each = var.node_groups

  cluster_name = aws_eks_cluster.this.name

  node_group_name = "${local.name_prefix}-${each.key}"

  node_role_arn = var.node_role_arn

  subnet_ids = var.private_subnet_ids

  instance_types = each.value.instance_types

  capacity_type = each.value.capacity_type

  disk_size = each.value.use_launch_template ? null : each.value.disk_size

  scaling_config {

    min_size = each.value.min_size

    max_size = each.value.max_size

    desired_size = each.value.desired_size

  }

  labels = each.value.labels

  dynamic "taint" {

    for_each = each.value.taints

    content {

      key = taint.value.key

      value = try(

        taint.value.value,

        null

      )

      effect = taint.value.effect

    }

  }

  dynamic "launch_template" {

    for_each = each.value.use_launch_template ? [each.key] : []

    content {

      id = aws_launch_template.this[launch_template.value].id

      version = "$Latest"

    }

  }

  tags = merge(

    local.common_tags,

    {

      Name = "${local.name_prefix}-eks-${each.key}"

    }

  )

  depends_on = [

    aws_eks_cluster.this

  ]

}
