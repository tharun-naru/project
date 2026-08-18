resource "aws_nat_gateway" "nat" {

  count = var.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id

  subnet_id = aws_subnet.public[count.index].id
  
  depends_on = [
    aws_internet_gateway.igw 
  ]


  tags = merge(
    local.common_tags,
    {

    Name = "${local.name_prefix}-nat-${count.index + 1}"

  }
)

}
