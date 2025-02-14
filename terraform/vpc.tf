resource "aws_vpc" "kd_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "kd-vpc"
  }
}

resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_s3_bucket.flow_logs.arn
  log_destination_type = "s3"
  traffic_type         = "REJECT"
  vpc_id               = aws_vpc.kd_vpc.id
}