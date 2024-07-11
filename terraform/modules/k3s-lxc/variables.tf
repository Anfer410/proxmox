variable "pve_details" {
  type = object({
    pve_user           = string
    pve_realm          = string
    pve_api_token      = string
    pve_api_token_name = string
    pve_node_id        = string
    pve_node_endpoint  = string
    pve_password       = string
  })
}

variable "id" {
  type = number
}

variable "lxc_template" {
  type = object({
    template_file_id = optional(string)
    type             = optional(string)
  })
}

variable "rootfs" {
  type = map(string)
  default = {
    "datastore_id" = "local-data"
    "size"         = 8
  }
}

variable "public_bridge" {
  type = string
}

variable "spec" {
  type = object({
    cpu_cores     = optional(number)
    dedicated_ram = optional(number)
    swap          = optional(number)
  })
}

# variable "datastore_id" {
#   type    = string
#   default = "local-data"
# }

# variable "datastore_size" {
#   type    = number
#   default = 12
# }

variable "tags" {
  type    = list(string)
  default = ["MbTF"]
}

# variable "node_token" {
#   type    = string
#   default = ""
# }

variable "agent_number" {
  type    = number
  default = 0
}
variable "prefix" {
  type    = string
  default = ""
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_private_key" {
  type = string
}