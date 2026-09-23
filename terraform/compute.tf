data "aws_ami" "ubuntu_2604" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "app_server_1" {
  ami                         = data.aws_ami.ubuntu_2604.id
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  key_name                    = aws_key_pair.project.key_name
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    encrypted             = true
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name        = "app-server-1"
    Project     = var.project_name
    Environment = var.environment
    Role        = "application"
    Monitoring  = "enabled"
  }
}

resource "aws_instance" "app_server_2" {
  ami                         = data.aws_ami.ubuntu_2604.id
  instance_type               = "t3.small"
  subnet_id                   = aws_subnet.public_b.id
  vpc_security_group_ids      = [aws_security_group.app.id]
  key_name                    = aws_key_pair.project.key_name
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    encrypted             = true
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name        = "app-server-2"
    Project     = var.project_name
    Environment = var.environment
    Role        = "application"
    Monitoring  = "enabled"
  }
}

resource "aws_instance" "db_server" {
  ami                         = data.aws_ami.ubuntu_2604.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.db.id]
  key_name                    = aws_key_pair.project.key_name
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 12
    encrypted             = true
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name        = "db-server"
    Project     = var.project_name
    Environment = var.environment
    Role        = "database"
    Monitoring  = "enabled"
  }
}

resource "aws_instance" "monitoring_server" {
  ami                         = data.aws_ami.ubuntu_2604.id
  instance_type               = "t3.medium"
  subnet_id                   = aws_subnet.public_b.id
  vpc_security_group_ids      = [aws_security_group.monitoring.id]
  key_name                    = aws_key_pair.project.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.monitoring.name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 15
    encrypted             = true
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = {
    Name        = "monitoring-server"
    Project     = var.project_name
    Environment = var.environment
    Role        = "monitoring"
    Monitoring  = "enabled"
  }
}
