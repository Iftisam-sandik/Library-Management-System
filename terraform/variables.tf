variable "aws_region" {
  description = "AWS region for the project"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project tag name"
  type        = string
  default     = "production-observability-platform"
}

variable "environment" {
  description = "Project environment"
  type        = string
  default     = "portfolio"
}

variable "vpc_cidr" {
  description = "CIDR block for the project VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A"
  type        = string
  default     = "10.20.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B"
  type        = string
  default     = "10.20.2.0/24"
}

variable "home_admin_cidr" {
  description = "Home public IP CIDR allowed for administrative access"
  type        = string
}
