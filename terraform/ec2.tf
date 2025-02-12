resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key"
  public_key = file(var.ssh_key_path)
}

resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.kd_public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.bastion_key.key_name

  tags = {
    Name = "kd-bastion"
  }

  depends_on = [aws_key_pair.bastion_key]
}

resource "aws_instance" "adder_service" {
  ami                         = var.ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.kd_private_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.bastion_key.key_name


  user_data = base64encode(<<-EOF
    #!/bin/bash
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    echo "Starting user_data script execution..."
    
    # Update and install dependencies
    apt-get update -y
    apt-get install -y python3.12-venv

    # Create app directory
    mkdir -p /app
    cd /app

    # Clone repository
    echo "Cloning repository..."
    git clone ${var.github_repo}
    cd "$(basename "${var.github_repo}" .git)"

    # Setup Python environment
    echo "Setting up Python environment..."
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r src/requirements.txt

    # Setup systemd service
    echo "Creating systemd service..."
    cat <<'SERVICE' > /etc/systemd/system/adder-service.service
    [Unit]
    Description=Adder Service
    After=network.target

    [Service]
    Type=simple
    User=ubuntu
    WorkingDirectory=/app/$(basename "${var.github_repo}" .git)/src
    Environment=DATABASE_HOST=${aws_db_instance.kd_postgres.address}
    Environment=DATABASE_PORT=${aws_db_instance.kd_postgres.port}
    Environment=DATABASE_NAME=${aws_db_instance.kd_postgres.db_name}
    Environment=DATABASE_USER=${var.database_username}
    Environment=DATABASE_PASS=${var.database_password}
    ExecStart=/app/$(basename "${var.github_repo}" .git)/.venv/bin/gunicorn --bind 0.0.0.0:80 adder_service_app:app
    Restart=always

    [Install]
    WantedBy=multi-user.target
    SERVICE

    # Start service
    echo "Starting service..."
    systemctl daemon-reload
    systemctl enable adder-service
    systemctl start adder-service

    echo "User data script completed."
    EOF
  )

  depends_on = [aws_db_instance.kd_postgres, aws_key_pair.bastion_key, aws_nat_gateway.nat_gw]
}
