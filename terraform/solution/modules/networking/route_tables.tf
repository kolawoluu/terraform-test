# Route tables: public (IGW), web/private (NAT), database (no internet)


# Public route table: default route to Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0" #Fixed the incorrect cidr block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.region}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  for_each = local.azs

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

# Web (private) route table(s): one per AZ, default route to NAT Gateway
resource "aws_route_table" "web" {
  for_each = local.azs

  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[each.key].id
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.region}-web-${local.azs[each.key].suffix}-rt"
  })
}

resource "aws_route_table_association" "web" {
  for_each = local.azs

  subnet_id      = aws_subnet.web[each.key].id
  route_table_id = aws_route_table.web[each.key].id
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.region}-database-rt"
  })
}

resource "aws_route_table_association" "database" {
  for_each = local.azs

  subnet_id      = aws_subnet.database[each.key].id
  route_table_id = aws_route_table.database.id
}

# # S3 VPC Endpoint (for backups, exports)
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = aws_vpc.vpc.id
#   service_name = "com.amazonaws.${var.region}.s3"
#   route_table_ids = [aws_route_table.database.id]
# }

