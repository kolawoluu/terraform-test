# Internet Gateway (for public subnets)

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, {
    Name = "${var.environment_name}-${var.region}-igw"
  })
}

