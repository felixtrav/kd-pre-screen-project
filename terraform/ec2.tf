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
  iam_instance_profile        = aws_iam_instance_profile.cloudwatch_profile.name


  user_data = base64encode(<<-EOF
    #!/bin/bash
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    
    # Update and install python venv package that isn't included for some god forsaken reason
    apt-get update -y
    apt-get install -y python3.12-venv

    # Install CloudWatch agent
    wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
    dpkg -i -E amazon-cloudwatch-agent.deb

    cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json << 'CONFIG'
    {
      "logs": {
        "logs_collected": {
          "files": {
            "collect_list": [
              {
                "file_path": "/var/log/adder-service.log",
                "log_group_name": "${aws_cloudwatch_log_group.adder_service.name}",
                "log_stream_name": "{instance_id}",
                "timezone": "UTC"
              }
            ]
          }
        }
      }
    }
    CONFIG

    # Download repo
    mkdir -p /app
    cd /app
    echo "Cloning repository..."
    git clone ${var.github_repo_url}
    cd ${var.github_repo_name}

    # Setup Python environment + install requirements
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
    User=root
    WorkingDirectory=/app/${var.github_repo_name}/src
    Environment="DATABASE_HOST=${aws_db_instance.kd_postgres.address}"
    Environment="DATABASE_PORT=${aws_db_instance.kd_postgres.port}"
    Environment="DATABASE_NAME=${aws_db_instance.kd_postgres.db_name}"
    Environment="DATABASE_USER=${var.database_username}"
    Environment="DATABASE_PASS=${var.database_password}"
    ExecStart=/app/${var.github_repo_name}/.venv/bin/gunicorn --bind 0.0.0.0:80 adder_service:app
    StandardOutput=append:/var/log/adder-service.log
    StandardError=append:/var/log/adder-service.log
    Restart=always

    [Install]
    WantedBy=multi-user.target
    SERVICE

    # Start services
    echo "Starting services..."
    
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
    systemctl start amazon-cloudwatch-agent
    systemctl enable amazon-cloudwatch-agent

    systemctl daemon-reload
    systemctl enable adder-service
    systemctl start adder-service

    echo "User data script completed."
    EOF
  )

  tags = {
    Name = "kd-adder-service"
  }

  depends_on = [aws_db_instance.kd_postgres, aws_key_pair.bastion_key, aws_nat_gateway.nat_gw]
}
