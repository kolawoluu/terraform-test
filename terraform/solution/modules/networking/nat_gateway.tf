# NAT Gateway(s): one per AZ for private subnet internet access

resource "aws_eip" "nat_eip" {
  for_each = local.azs

  domain = "vpc"

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.availability_zones[each.key]}-nat-eip"
  })
}

resource "aws_nat_gateway" "nat_gateway" {
  for_each = local.azs

  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.availability_zones[each.key]}-nat"
  })
}
