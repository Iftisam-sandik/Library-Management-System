variable "admin_cidr" {
  description = "Public IP CIDR allowed for administrative access"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the local SSH public key"
  type        = string
  default     = "~/.ssh/observability-project.pub"
}
