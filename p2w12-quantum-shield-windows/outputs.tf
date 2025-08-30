output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.quantum_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_app_subnet_id" {
  description = "ID of the private app subnet"
  value       = aws_subnet.private_app_subnet.id
}

output "private_data_subnet_id" {
  description = "ID of the private data subnet"
  value       = aws_subnet.private_data_subnet.id
}

output "kali_instance_id" {
  description = "ID of the Kali attacker instance"
  value       = aws_instance.kali_attacker.id
}

output "kali_public_ip" {
  description = "Public IP of the Kali attacker instance"
  value       = aws_instance.kali_attacker.public_ip
}

output "vuln_instance_id" {
  description = "ID of the vulnerable target instance"
  value       = aws_instance.vuln_target.id
}

output "vuln_private_ip" {
  description = "Private IP of the vulnerable target instance"
  value       = aws_instance.vuln_target.private_ip
}

output "kali_security_group_id" {
  description = "ID of the Kali security group"
  value       = aws_security_group.kali_sg.id
}

output "vuln_security_group_id" {
  description = "ID of the vulnerable target security group"
  value       = aws_security_group.vuln_sg.id
}

output "ssh_command" {
  description = "SSH command to connect to Kali instance"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${aws_instance.kali_attacker.public_ip}"
}
