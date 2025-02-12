resource "aws_vpc" "kd_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "kd-vpc"
  }
}