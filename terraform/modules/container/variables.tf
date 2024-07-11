variable "node_id" {
  type = string
}

variable "node_endpoint" {
  type = string
}

variable "id" {
  type = number
}

variable "hostname" {
  type     = string
  nullable = true
  default  = null
}

variable "pve_user" {
  type = string
}

variable "pve_api_token" {
  type = string
}

variable "pve_token_name" {
  type = string
}

variable "pve_realm" {
  type = string
}

variable "lxc_template" {
  type = map(string)
  default = {
    "template_file_id" = ""
    "type"             = ""
  }
}

variable "unprivileged" {
  type    = bool
  default = true
}

variable "rootfs" {
  type = map(any)
  default = {
    "datastore_id" = ""
    "size"         = 8

  }
}

variable "ssh_location" {
  type    = string
  default = null
}

variable "spec" {
  type = map(any)
  default = {
    cpu_cores     = 1
    dedicated_ram = 1024
    swap          = 0
  }

}

variable "pool_id" {
  type    = string
  default = null
}

variable "network_interfaces" {
  type = map(object({
    bridge    = optional(string)
    vlan      = optional(number)
    enabled   = optional(bool)
    firewall  = optional(bool)
    ratelimit = optional(number)

    ip_config = optional(object({
      ipv4 = optional(object({
        address = optional(string, null)
        gateway = optional(string)
      }))
      ipv6 = optional(object({
        address = optional(string)
        gateway = optional(string)
      }))
    }))
  }))

}

variable "features_nesting" {
  type    = bool
  default = false
}

variable "features_fuse" {
  type    = bool
  default = false
}

variable "tags" {
  type    = list(string)
  default = []
}

variable "password" {
  type    = string
  default = "start2024"
}

variable "started" {
  type    = bool
  default = false
}

variable "start_on_boot" {
  type    = bool
  default = false
}

variable "ssh_public_key" {
  type      = string
  sensitive = true
}
