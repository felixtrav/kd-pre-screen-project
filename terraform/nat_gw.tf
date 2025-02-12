# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "kd-nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.kd_public_subnets[0].id

  tags = {
    Name = "kd-nat-gw"
  }

  depends_on = [aws_internet_gateway.kd_igw]
}
