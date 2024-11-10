cluster_data = {
  name = "talos"
}

talos_image = {
  version           = "v1.8.1"
  arch              = "amd64"
  platform          = "nocloud"
  proxmox_datastore = "nas-tank"
  proxmox_node      = "epsilon"
  schematic_id      = "4d2f14467f85468b6b5ff0ba1747f7f0bcb97d351d516db0197885247093d6fd"
}

vm_data = {
  network_gateway       = "192.168.0.1"
  network_subnet_range  = 23
  starting_vmid         = 600
  cloud_init_datastore  = "local-lvm"
}

node_definition = {
  masters = {
    "192.168.1.30" = {
      node                = "epsilon"
      cores               = 4
      memory              = 8196
      boot_disk_size      = 40
      boot_disk_datastore = "samsung-ssd"
      extra_disks         = []
    }
  }
  workers = {
    "192.168.1.35" = {
      node                = "epsilon"
      cores               = 4
      memory              = 8196
      boot_disk_size      = 40
      boot_disk_datastore = "samsung-ssd"
      extra_disks = [
        {
          datastore = "nvme-ssd"
          size      = 60
        }
      ]
    }
  }
}
