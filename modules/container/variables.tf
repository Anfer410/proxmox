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
  # default   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCs6g0rxhS00vTapiiCU6Jwmw1qNpG7BFgRmRRTQQtCqKycxQe80qPRKXYX/mO0bdaOFaQHSMNj3//t3foCbcR0dXOkmU6QXaweJlVO9rUGPbLtEJdB8toY1Zmb9ZIB4bhyQHdOrbeFie6W2Y0sHF0iAmeK6IlvKNTFDksqYveQJFjLCgbiIi5K3xTBvlZbn40cA5zRdmlww/0XuMBjUbsqqfM34yfJ/pGBj30I7jNPMOcmH9XbN3OtbmPCD0+kvKPCOPN3nB7Y9H4QONJtqhGzBal7S62gBlVWZTRAOMGrV74cQNavYyJO5vBJEB4ttebNu2FJ0MR3raqWB6p9KexZI6sEsPge9Zb39OCH+oO1H3Hmn6aSYUSkxnYxHM/C6zaYZwA6GI8odaT2ul8xoE5E+TS1qw6wgTznvmSb8OiSmGAqKzNpYY+wTDucEmBR2P3GWPcEKUlUbFk6TkaEEhPtH37a6poHdwGRXp4vFIyIFromhsoZmNB/1Th46+kgeMOlQ7ZX/VtBWZt3cr8uLkgVw4F4LmC45MWzVk923WuU+/DgjMRt/aBV5Fo4s10h3WJS4wxID97w9EgP42sOHS0KxZxREn6mt9E4iO8lbSeiBauY4GbLcZ3qVOhzfbf5ByQHHCJmfjyEYh5KgB9A9JpIDP152qk10rClgz79MekViQ== default@terraform"
}

variable "ssh_private_key" {
  type      = string
  sensitive = true
#   default   = <<EOH
# -----BEGIN OPENSSH PRIVATE KEY-----
# b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAACFwAAAAdzc2gtcn
# NhAAAAAwEAAQAAAgEArOoNK8YUtNL02qYoglOicJsNajaRuwRYEZkUU0ELQqisnMUHvNKj
# 0Sl2F/5jtG3WjhWkB0jDY9//7d36Am3EdHVzpJlOkF2sHiZVTva1Bj2y7RCXQfLaGNWZm/
# WSAeG4ckB3Tq23hYnultmNLBxdIgJniuiJbyjUxQ5LKmL3kCRYywoG4iIuSt8Uwb5WW5+N
# HAOc0XZpcMP9F7jAY1G7KqnzN+Mnyf6RgY99CO4zTzDnJh/V2zdzrW5jwg9PpLyjwjjzd5
# we2PR+EDjSbaoRswWpe0utoAZVVmU0QDjBq1e+HEDWr2MiTubwSRAeLbXmzbthSdDEd62q
# lgeqfSnsWSOrBLD4HvWW9/Tgh/qDtR9x5p+mkmFEpMZ2MRzPwus2mGcAOhiPKHWk9rpfMa
# BORPk0tasOsIE8575km/DokphgKiszaWGPsEw7nBJgUdj9xlj3BClJVGxZOk5GhBIT7R9+
# 2uqaB3cBkV6eLxSMiBa6JobKGZjQf9U4eOvpIHjDpUO2V/1bQVmbd3K/Li5IFcOBeC5guO
# TFs1ZPdt1rlPvw4IzEbf2gVeRaOLNdId1iUuMMSA/e8PRID+NrDh0tCsWcURJ+prfROIjv
# JW0nogWrmOBmy3Gd6lToc323+QckBxwiZn48hGIeSoAfQPSaSAz9edqpNdKwpYM+/THpFY
# kAAAdIYR1L12EdS9cAAAAHc3NoLXJzYQAAAgEArOoNK8YUtNL02qYoglOicJsNajaRuwRY
# EZkUU0ELQqisnMUHvNKj0Sl2F/5jtG3WjhWkB0jDY9//7d36Am3EdHVzpJlOkF2sHiZVTv
# a1Bj2y7RCXQfLaGNWZm/WSAeG4ckB3Tq23hYnultmNLBxdIgJniuiJbyjUxQ5LKmL3kCRY
# ywoG4iIuSt8Uwb5WW5+NHAOc0XZpcMP9F7jAY1G7KqnzN+Mnyf6RgY99CO4zTzDnJh/V2z
# dzrW5jwg9PpLyjwjjzd5we2PR+EDjSbaoRswWpe0utoAZVVmU0QDjBq1e+HEDWr2MiTubw
# SRAeLbXmzbthSdDEd62qlgeqfSnsWSOrBLD4HvWW9/Tgh/qDtR9x5p+mkmFEpMZ2MRzPwu
# s2mGcAOhiPKHWk9rpfMaBORPk0tasOsIE8575km/DokphgKiszaWGPsEw7nBJgUdj9xlj3
# BClJVGxZOk5GhBIT7R9+2uqaB3cBkV6eLxSMiBa6JobKGZjQf9U4eOvpIHjDpUO2V/1bQV
# mbd3K/Li5IFcOBeC5guOTFs1ZPdt1rlPvw4IzEbf2gVeRaOLNdId1iUuMMSA/e8PRID+Nr
# Dh0tCsWcURJ+prfROIjvJW0nogWrmOBmy3Gd6lToc323+QckBxwiZn48hGIeSoAfQPSaSA
# z9edqpNdKwpYM+/THpFYkAAAADAQABAAACACgDfnpFe4evtKE/Z6rnCzVXMCbGy3j1Y6Lo
# 43Lzn5U0nsMldimsLeQKXe1l/TEk5Mxa9isIW8zKKnmjT0ZOG/LeNh1eK7fNMXYFpWKhRR
# lVYEkrOHF2ryEllscoL/o2/32S7Pj8SraAiYGHhPty8dtbppXWw20BjCEwslSz87l7q7+K
# iba9Nay2TGGcN/Q6awdTT7AKIJLLi884Pe8N3Aveqa2iZ5P/ELFkYMkXBDEcbjUck1rIDY
# ESBUxESkgjLhsVHkQs0NegVmbPG2TswO1GT2a8h8h7Brb4Mvv0ll6d7pyvpW6POIJ9PxgN
# PoqR6D/uD3CrOre+LLZMvld6AtrpZQlc6iYWTT5jvCeoteHKG4OhAd7xYl0+jcH8Kuf3De
# q0a3+N4K5XqSvwb18fue5N950vKZNWmvzekS5Ol7DqT+QbkzjFY4+iutN9P3oXG63F9+XO
# 970aaT754uOMOiwGw64BV43sninZBvQw8idcCNr95022SgHhtQvPqTRY54CG5UeluotEoR
# gGObjRdYOf8JuK/qKW7yT/pOuL0X20Ff8+0v+jJuNHICyewxN0/QyTtIltiPAVI97GyJW3
# hFctimonTkWfWbVKUXVeWY0e98q4FTKZyOlWw6ikSA0PxXbybLz7CYY5eogdMZIM2BniDl
# CgD8Gvt+cTdgDcc5GtAAABADNlgWgVPGU8q8Zy4Hy24s+nFue1+ACPa863l31RAJF0PrJV
# 4YeAbA38uUyHkl07byunJ9vYRiSDtjRe4i/sBfpW4u7BxElLzUl5S0fzk5j/B21Mt+bJ6g
# B7745AYIgos/oNeKgdAJn2yJYi9yC+szQQElw+RfzkjOKVBRrZyZbaBsD62lIOkbLIgcRt
# YPiqujK4x2ESl+iHuxlu7Xj3yz1ee7UQCIipjJge+ib7gLM4h9rR7jT6NTBo0LbPA/sXWP
# pBs4caUBepEiLHLVSkbocIHO7fgYcD/xnCFj4/3WkUgdFnsjtIsUAb+qYIQ4LDSn9YDuzO
# Zp0qIJyH8b57mocAAAEBANv5X2AgFAr7GFQoHurUHGXA3BzvVJRkVSmr/4/CfL7+ahL2yi
# nX1zMLLZIF1dOcrgqrNQWr6XC9DRCSzjPPCheuyfx9iL3gzrM2yjxr2OrhTgNv2rSA+5oI
# o+hsfSMkz2KPncdu7cP2COLhTDCMcw/CjLmmSMQXduj/hnOLtI+xupJHyfRfPNLJd0YYii
# zoSHeczlgicYo40muxJ3FfgFzD36w+nULwCdxIVpKN1h+WTrQl78h8GmTT7uofTJvhD3V8
# HAavrNp9s4X5tRfumxQLNjW5fHojQbF7xyeERmVB0NQhnXl52vkQp8hs0efQJkywEoCrw7
# LTyhPM60XyQ4UAAAEBAMk7pjPsf0N+fqFzHW+w56CmIv/FtnazvshAfj9GMzz0MjApw11b
# cqBdjkT6DFBGAw0B1H5USkq1lYl4tmBMBpsSROI1VFJDvQSM2UuoE1o5VkwJ1+OvMKx/VJ
# wH3+m1zLF9k3hyIboqv9Nt5oJGfhPdPN8s8inXZ1AYU3KC7//6mAL8v4k0/PuGBC++ibhN
# jILhbUx7P5VdfjE7zqOyOABSZD2kYbf7spLtPJGdzcbG7hqZeG4aW2bLXNDHCSfDeRFdJ2
# Ym+1s73j1SZQOHSLER43fw31Jeu5EFXknGYE6DHkimWw6EXHZSKce794o9f+KGBENRWTww
# uJ9SD1CEHzUAAAATYW5keUBhbmR5LXBjLWRlYmlhbg==
# -----END OPENSSH PRIVATE KEY-----
# EOH
}