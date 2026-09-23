output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_b.id
}

output "public_subnet_a_az" {
  value = aws_subnet.public_a.availability_zone
}

output "public_subnet_b_az" {
  value = aws_subnet.public_b.availability_zone
}

output "internet_gateway_id" {
  value = aws_internet_gateway.main.id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "ubuntu_2604_ami_id" {
  value = data.aws_ami.ubuntu_2604.id
}

output "ubuntu_2604_ami_name" {
  value = data.aws_ami.ubuntu_2604.name
}

output "app_server_1_instance_id" {
  value = aws_instance.app_server_1.id
}

output "app_server_1_public_ip" {
  value = aws_instance.app_server_1.public_ip
}

output "app_server_1_private_ip" {
  value = aws_instance.app_server_1.private_ip
}

output "app_server_2_instance_id" {
  value = aws_instance.app_server_2.id
}

output "app_server_2_public_ip" {
  value = aws_instance.app_server_2.public_ip
}

output "app_server_2_private_ip" {
  value = aws_instance.app_server_2.private_ip
}

output "db_server_instance_id" {
  value = aws_instance.db_server.id
}

output "db_server_public_ip" {
  value = aws_instance.db_server.public_ip
}

output "db_server_private_ip" {
  value = aws_instance.db_server.private_ip
}

output "monitoring_server_instance_id" {
  value = aws_instance.monitoring_server.id
}

output "monitoring_server_public_ip" {
  value = aws_instance.monitoring_server.public_ip
}

output "monitoring_server_private_ip" {
  value = aws_instance.monitoring_server.private_ip
}
