resource "aws_security_group" "this" {

  name = "${local.db_identifier}-sg"

  description = "Security Group for RDS"

  vpc_id = var.vpc_id

  tags = merge(

    local.common_tags,

    {

      Name = "${local.db_identifier}-sg"

    }

  )

}

resource "aws_vpc_security_group_ingress_rule" "this" {

  for_each = var.security_group_ingress

  security_group_id = aws_security_group.this.id

  description = lookup(each.value, "description", null)

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

resource "aws_vpc_security_group_egress_rule" "this" {

  security_group_id = aws_security_group.this.id

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"

}
