cat > outputs.tf << 'EOF'
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
  value       = aws_eip.kali_eip.public_ip
}

output "vuln_instance_id" {
  description = "ID of the vulnerable target instance"
  value       = aws_instance.vuln_target.id
}

output "vuln_public_ip" {
  description = "Public IP of the vulnerable target instance"
  value       = aws_eip.vuln_eip.public_ip
}

output "kali_security_group_id" {
  description = "ID of the Kali security group"
  value       = aws_security_group.kali_sg.id
}

output "vuln_security_group_id" {
  description = "ID of the vulnerable target security group"
  value       = aws_security_group.vuln_sg.id
}

output "key_pair_name" {
  description = "ID of the SSH key pair"
  value       = aws_key_pair.quantum_key.key_name
}
