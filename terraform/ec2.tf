resource "aws_instance" "adder_service" {
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  subnet_id                   = aws_subnet.kd_private_subnet.id
  associate_public_ip_address = false

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",                                               # Update package lists (for ubuntu)
      "sudo apt install git -y",                                          # Install git
      "git clone ${var.github_repo} && cd \"$(basename \"$_\" .git)\"",   # Clone the repository
      "python3 -m venv .venv",                                            # Create a virtual environment
      "source .venv/bin/activate && pip install -r src/requirements.txt", # Activate venv and install dependencies
      "cd src",
      "DATABASE_HOST=${aws_db_instance.kd_postgres.address}",
      "DATABASE_PORT=${aws_db_instance.kd_postgres.port}",
      "DATABASE_NAME=${aws_db_instance.kd_postgres.db_name}",
      "DATABASE_USER=${var.database_username}",
      "DATABASE_PASS=${var.database_password}",
      "gunicorn --bind 0.0.0.0:5000 adder_service_app:app",
    ]
  }
}
