resource "aws_route_table_association" "kd_rta1" {
  subnet_id      = aws_subnet.kd_public_subnet.id
  route_table_id = aws_route_table.kd_rt.id
}