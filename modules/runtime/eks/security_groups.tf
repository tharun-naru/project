resource "aws_security_group" "additional" {

  count = var.create_additional_security_group ? 1 : 0

  name = "${local.name_prefix}-eks-additional-sg"

  description = "Additional security group for EKS nodes"

  vpc_id = var.vpc_id

  tags = merge(

    local.common_tags,

    {

      Name = "${local.name_prefix}-eks-additional-sg"

      "karpenter.sh/discovery" = var.karpenter_discovery_tag

    }

  )

}

resource "aws_vpc_security_group_ingress_rule" "additional" {

  for_each = var.create_additional_security_group ? var.additional_security_group_ingress : {}

  security_group_id = aws_security_group.additional[0].id

  description = each.value.description

  from_port = each.value.from_port

  to_port = each.value.to_port

  ip_protocol = each.value.protocol

  cidr_ipv4 = (

    length(each.value.cidr_blocks) == 1

    ? each.value.cidr_blocks[0]

    : null
  )

  referenced_security_group_id = (
    length(each.value.security_group_ids) == 1

    ? each.value.security_group_ids[0]

    : null
  )

}
