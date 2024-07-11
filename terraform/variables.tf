variable "pve_node_endpoint" {
  type = string
}

variable "pve_node_id" {
  type = string
}

variable "pve_user" {
  type = string
}

variable "pve_realm" {
  type    = string
  default = "pam"
}

variable "pve_api_token" {
  type = string
}

variable "pve_api_token_name" {
  type = string
}

variable "pve_password" {
  type = string
}

variable "public_bridge" {
  type    = string
  default = "vmbr0"
}

variable "agent_number" {
  type    = number
  default = 2
}

variable "id_start" {
  type = number
  default = 1000
}

variable "pull_ct" {
  type = bool
  default = true
}

variable "debian_image_location" {
  type = string
  default = ""
}