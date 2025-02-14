variable "database_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
  default     = "testing123"
}

variable "region" {
  description = "The region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "database_username" {
  description = "The username for the database"
  type        = string
  default     = "postgres"
}

variable "ami_id" {
  description = "The AMI image to use for the VM"
  type        = string
  default     = "ami-04b4f1a9cf54c11d0" # Ubuntu 24.04 LTS us-east-1 image
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.10.0/24"]
}

variable "private_subnet_cidr" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.30.0/24"]
}

variable "ec2_instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "availability_zones" {
  description = "The availability zone for the subnet"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "ssh_key_path" {
  description = "The path to the SSH key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# !------- Start of variables without defaults -------! #

variable "allowed_bastion_ips" {
  description = "The allowed IP addresses for the bastion host"
  type        = list(string)
}

variable "github_repo_url" {
  description = "The URL for GitHub repository to clone"
  type        = string
}

variable "github_repo_name" {
  description = "The name of GitHub repository being cloned"
  type        = string
}


variable "display_service_image" {
  description = "The Docker image for the display service"
  type        = string
}

variable "reset_service_image" {
  description = "The Docker image for the reset service"
  type        = string
}