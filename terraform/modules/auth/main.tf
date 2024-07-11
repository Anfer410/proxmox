resource "random_password" "password" {
  count = var.generate_password ? 1 :0 
  length           = 16
  override_special = "_%@"
  special          = true
}

resource "tls_private_key" "key_pair" {
  count = var.generate_key_pair ? 1 : 0 
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key_file" {
  filename        = "${var.path_to_file}"
  content         = tls_private_key.key_pair[0].private_key_pem
  file_permission = 0400
}

output "password" {
  value     = var.generate_password ? random_password.password[0].result : ""
  sensitive = true
}

output "private_key" {
  value     = var.generate_key_pair ? tls_private_key.key_pair[0].private_key_pem : ""
  sensitive = true
}

output "public_key" {
  value = var.generate_key_pair ? tls_private_key.key_pair[0].public_key_openssh : ""
}