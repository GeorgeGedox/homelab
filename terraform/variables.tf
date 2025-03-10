locals {
  _merged_node_definitions = merge(
    { for ip, values in var.node_definition.masters : ip => merge(values, { type = "master" }) },
    { for ip, values in var.node_definition.workers : ip => merge(values, { type = "worker" }) }
  )

  _first_controlplane = [for ip, values in var.node_definition.masters : ip][0]

  _type_index_map = {
    for type, nodes in {
      master = var.node_definition.masters
      worker = var.node_definition.workers
      } : type => {
      for ip, values in nodes : ip => index(keys(nodes), ip)
    }
  }
}

variable "cluster_data" {
  description = "General cluster values"
  type = object({
    name                 = string
    proxmox_cluster_name = string
  })
}

variable "talos_image" {
  description = "Values to download the Talos base image"
  type = object({
    version           = string
    arch              = string
    platform          = string
    proxmox_datastore = string
    proxmox_node      = string
    schematic_id      = string
  })
}

variable "vm_data" {
  description = "Common values for Proxmox VM creation"
  type = object({
    network_gateway      = string
    network_subnet_range = number
    starting_vmid        = number
    cloud_init_datastore = string
  })
}

variable "node_definition" {
  description = "Definitions of the VMs to be created"
  type = object({
    masters = map(object({
      name                = optional(string)
      description         = optional(string)
      node                = string
      cores               = number
      memory              = number
      boot_disk_size      = number
      boot_disk_datastore = string
      extra_disks = list(object({
        datastore = string
        size      = number
      }))
    }))
    workers = map(object({
      name                = optional(string)
      description         = optional(string)
      node                = string
      cores               = number
      memory              = number
      boot_disk_size      = number
      boot_disk_datastore = string
      extra_disks = list(object({
        datastore = string
        size      = number
      }))
    }))
  })
}
