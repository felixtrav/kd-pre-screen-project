variable "database_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
  default     = "testing123"
}

variable "region" {
  description = "The region to deploy the resources"
  type        = string
}

variable "database_username" {
  description = "The username for the database"
  type        = string
}

variable "ami_id" {
  description = "The AMI image to use for the VM"
  type        = string
}

variable "github_repo" {
  description = "The GitHub repository to clone"
  type        = string
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
}

variable "availability_zones" {
  description = "The availability zone for the subnet"
  type        = list(string)
}

variable "allowed_bastion_ips" {
  description = "The allowed IP addresses for the bastion host"
  type        = list(string)
}

variable "ssh_key_path" {
  description = "The path to the SSH key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}