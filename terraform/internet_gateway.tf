resource "aws_internet_gateway" "kd_igw" {
  vpc_id = aws_vpc.kd_vpc.id
}