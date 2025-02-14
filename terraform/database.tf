resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "kd-db-subnet-group"
  subnet_ids = aws_subnet.kd_private_subnets[*].id
  tags = {
    Name = "kd-db-subnet-group"
  }
}

resource "aws_db_instance" "kd_postgres" {
  allocated_storage      = 5
  identifier             = "kd-backend-rds"
  db_name                = "postgres"
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true

  username = var.database_username
  password = var.database_password

  tags = {
    Name = "kd-db-postgres"
  }
}