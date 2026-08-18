resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {

    Name = "${local.name_prefix}-igw"
  }
)
}

