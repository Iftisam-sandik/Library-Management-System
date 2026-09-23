resource "aws_key_pair" "project" {
  key_name   = "production-observability-key"
  public_key = file(pathexpand(var.ssh_public_key_path))

  tags = {
    Name        = "production-observability-key"
    Project     = var.project_name
    Environment = var.environment
  }
}
