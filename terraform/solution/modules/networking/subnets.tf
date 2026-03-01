# Subnets: public, web (private), and database (private)


resource "aws_subnet" "public" {
  for_each = local.azs

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[each.key]
  availability_zone       = var.availability_zones[each.key]
  map_public_ip_on_launch = var.map_public_ip_on_launch_public

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.availability_zones[each.key]}-public-subnet"
    Tier = "public"
  })
}

resource "aws_subnet" "web" {
  for_each = local.azs

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.web_subnet_cidr_blocks[each.key]
  availability_zone       = var.availability_zones[each.key]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.availability_zones[each.key]}-web-subnet"
    Tier = "private"
  })
}

resource "aws_subnet" "database" {
  for_each = local.azs

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.database_subnet_cidr_blocks[each.key]
  availability_zone       = var.availability_zones[each.key]
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.availability_zones[each.key]}-database-subnet"
    Tier = "private"
  })
}
