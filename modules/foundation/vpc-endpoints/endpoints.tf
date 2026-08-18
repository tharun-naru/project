resource "aws_vpc_endpoint" "gateway" {
  for_each = var.gateway_endpoints

  vpc_id = var.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.name}.${each.key}"

  vpc_endpoint_type = "Gateway"

  route_table_ids = var.private_route_table_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-${each.key}-endpoint"
    }
  )
}

resource "aws_vpc_endpoint" "interface" {
  for_each = var.interface_endpoints

  vpc_id = var.vpc_id

  service_name = "com.amazonaws.${data.aws_region.current.name}.${each.key}"

  vpc_endpoint_type = "Interface"

  subnet_ids = var.private_subnet_ids

  security_group_ids = [
    coalesce(
      var.endpoint_security_group_id,
      aws_security_group.endpoint[0].id
    )
  ]

  private_dns_enabled = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-${each.key}-endpoint"
    }
  )
}
