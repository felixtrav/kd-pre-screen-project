resource "aws_subnet" "kd_public_subnets" {
  count             = length(var.public_subnet_cidrs)
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = var.availability_zones[count.index]

  vpc_id = aws_vpc.kd_vpc.id

  tags = {
    Name = "kd-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "kd_private_subnets" {
  count             = length(var.private_subnet_cidr)
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = var.availability_zones[count.index]

  vpc_id = aws_vpc.kd_vpc.id

  tags = {
    Name = "kd-private-subnet-${count.index + 1}"
  }
}