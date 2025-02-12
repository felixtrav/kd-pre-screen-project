resource "aws_route_table_association" "kd_public_rta" {
  count          = length(aws_subnet.kd_public_subnets)
  subnet_id      = aws_subnet.kd_public_subnets[count.index].id
  route_table_id = aws_route_table.kd_public_rt.id
}

# Associate private subnets with private route table
resource "aws_route_table_association" "kd_private_rta" {
  count          = length(aws_subnet.kd_private_subnets)
  subnet_id      = aws_subnet.kd_private_subnets[count.index].id
  route_table_id = aws_route_table.kd_private_rt.id
}