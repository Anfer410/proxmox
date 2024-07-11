module auth {
    source = "../auth"
    path_to_file = "${path.module}/../../${var.path_to_ssh_keys}/${local.prefix}k3s.pem"
    generate_key_pair = true
    generate_password = false
}