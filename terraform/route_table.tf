resource "aws_route_table" "kd_public_rt" {
  vpc_id = aws_vpc.kd_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kd_igw.id
  }
}

# Route table for private subnets
resource "aws_route_table" "kd_private_rt" {
  vpc_id = aws_vpc.kd_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "kd-private-rt"
  }
}