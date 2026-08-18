resource "aws_security_group" "endpoint" {
  count = var.create_endpoint_security_group ? 1 : 0

  name        = "${local.name_prefix}-endpoint-sg"
  description = "Security group for VPC interface endpoints"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-endpoint-sg"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  for_each = var.create_endpoint_security_group ? toset(
    var.interface_endpoint_ingress_cidr_blocks
  ) : []

  security_group_id = aws_security_group.endpoint[0].id

  description = "HTTPS access to VPC interface endpoints"

  from_port = 443
  to_port   = 443

  ip_protocol = "tcp"

  cidr_ipv4 = each.value
}
