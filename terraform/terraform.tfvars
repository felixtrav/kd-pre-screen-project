region              = "us-east-1"
database_username   = "postgres"
ami_id              = "ami-04b4f1a9cf54c11d0" # Ubuntu 24.04 LTS us-east-1 image
github_repo         = "https://github.com/felixtrav/kd-pre-screen-project"
ec2_instance_type   = "t2.micro"
availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
allowed_bastion_ips = ["45.17.44.180/32"]