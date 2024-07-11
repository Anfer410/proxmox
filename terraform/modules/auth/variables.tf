variable "path_to_file" {
  type        = string
  description = "path to save private key"
}
# ../ssh/debian-ct.pemkey_pair

variable "generate_password" {
  type = bool
  default = false
}

variable "generate_key_pair" {
  type = bool
  default = true
}