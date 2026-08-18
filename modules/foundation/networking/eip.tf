resource "aws_eip" "nat" {

  count = var.nat_gateway_count

  domain = "vpc"

  tags = merge( 
    local.common_tags,
    {
    Name = "${local.name_prefix}-nat-eip-${count.index + 1}"
  }
 )
}

