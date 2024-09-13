locals {
  _merged_node_definitions = merge({
    for ip, values in var.node_definition.masters : ip => merge(values, { type = "master" })
    }, {
    for ip, values in var.node_definition.workers : ip => merge(values, { type = "worker" })
  })

  _first_controlplane = [for ip, values in var.node_definition.masters : ip][0]
}

variable "cluster_data" {
  description = "General cluster values"
  type = object({
    name = string
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
