output "vpc_id" {
  value = aws_vpc.secure_vpc.id
}

output "private_server_internal_ip" {
  value = aws_instance.private_ec2.private_ip
}