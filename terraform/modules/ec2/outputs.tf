output "public_web_instance_id" {
  description = "ID of the public web server instance"
  value       = aws_instance.public_web.id
}

output "public_web_public_ip" {
  description = "Public IP of the web server instance"
  value       = aws_instance.public_web.public_ip
}

output "private_db_instance_id" {
  description = "ID of the private database server instance"
  value       = aws_instance.private_db.id
}

output "private_db_private_ip" {
  description = "Private IP of the database server instance"
  value       = aws_instance.private_db.private_ip
}

output "key_pair_name" {
  description = "Name of the key pair"
  value       = aws_key_pair.lab_key.key_name
}
