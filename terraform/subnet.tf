resource "aws_subnet" "kd_public_subnet" {
  vpc_id            = aws_vpc.kd_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.subnet_az
}

resource "aws_subnet" "kd_private_subnet" {
  vpc_id            = aws_vpc.kd_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.subnet_az
}