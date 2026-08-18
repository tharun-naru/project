####################################
# Public Route Table
####################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }

  tags = merge(
    local.common_tags,
    {
    Name = "${local.name_prefix}-public-rt"
    
  }
)
}

####################################
# Private Route Table
####################################

resource "aws_route_table" "private" {

  count = var.nat_gateway_count

  vpc_id = aws_vpc.this.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat[count.index].id

  }

  tags = merge(
    local.common_tags,
    {

    Name = "${local.name_prefix}-private-rt-${count.index + 1}"

  }
)
}

###########################################
# Public Route Table Associations
###########################################

resource "aws_route_table_association" "public_subnet_a" {

  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

}


###########################################
# Private Route Table Associations
###########################################

resource "aws_route_table_association" "private_subnet_a" {

  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id

}

