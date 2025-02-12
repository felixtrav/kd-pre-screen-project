variable "database_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "whitelisted_ip_address" {
  description = "IP address to whitelist for the resources"
  type        = string
  sensitive   = true
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

variable "public_subnet_cidr" {
  description = "The CIDR blocks for the public subnets"
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "The CIDR blocks for the private subnets"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ec2_instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "subnet_az" {
  description = "The availability zone for the subnet"
  type        = string
}
