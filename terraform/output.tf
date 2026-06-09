output "server_ip" {
  description = "Server Public IP"
  value       = aws_instance.minecraft_server.public_ip
}
