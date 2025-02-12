
# Data source: query the list of availability zones
data "aws_availability_zones" "all" {}

resource "aws_security_group" "web_sg" {
  name   = "kd-web-sg"
  vpc_id = aws_vpc.kd_vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kd-web-sg"
  }
}

resource "aws_security_group" "db_sg" {
  name   = "kd-db-sg"
  vpc_id = aws_vpc.kd_vpc.id

  ingress {
    description = "PostgreSQl from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kd-db-sg"
  }
}

resource "aws_security_group" "lb_sg" {
  name   = "kd-lb-sg"
  vpc_id = aws_vpc.kd_vpc.id

  ingress {
    description = "HTTP from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kd-db-sg"
  }
}

resource "aws_security_group" "bastion_sg" {
  name   = "kd-bastion-sg"
  vpc_id = aws_vpc.kd_vpc.id

  ingress {
    description = "SSH from user IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_bastion_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kd-db-sg"
  }
}