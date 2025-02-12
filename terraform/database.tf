resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "kd-db-subnet-group"
  subnet_ids = [aws_subnet.kd_private_subnet.id]
  tags = {
    Name = "kd-db-subnet-group"
  }
}

resource "aws_db_instance" "kd_postgres" {
  allocated_storage    = 5
  identifier           = "kd-backend-rds"
  db_name              = "kd-db-postgres"
  engine               = "postgres"
  engine_version       = "16.3-R3"
  instance_class       = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.postgres_subnet_group.id
  publicly_accessible  = false

  username = var.database_username
  password = var.database_password

  tags = {
    Name = "kd-db-postgres"
  }
}