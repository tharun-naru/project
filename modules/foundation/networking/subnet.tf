resource "aws_subnet" "public" {

  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[var.availability_zone_indexes[count.index]]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
    Name = "${local.name_prefix}-public-subnet-${count.index + 1}"
  },
  var.karpenter_discovery_tag == null ? {} : {
    "karpenter.sh/discovery" = var.karpenter_discovery_tag
  }

)
}

resource "aws_subnet" "private" {

  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[var.availability_zone_indexes[count.index]]

  tags = merge(
    local.common_tags,
    {
    Name = "${local.name_prefix}-private-subnet-${count.index + 1}"
  },
  var.karpenter_discovery_tag == null ? {} : {
    "karpenter.sh/discovery" = var.karpenter_discovery_tag
  }
)
}
