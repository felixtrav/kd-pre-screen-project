resource "aws_route_table" "kd_rt" {
  vpc_id = aws_vpc.kd_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kd_igw.id
  }
}