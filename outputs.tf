output "instance_private_ips" {
  value = aws_instance.splunk[*].private_ip
}

output "instance_public_ips" {
  value = aws_instance.splunk[*].public_ip
}