cluster_data = {
  name = "talos"
}

talos_image = {
  version           = "v1.8.1"
  arch              = "amd64"
  platform          = "nocloud"
  proxmox_datastore = "nas-tank"
  proxmox_node      = "epsilon"
  schematic_id      = "831bcd3df93662159641b00d8b3bb96edc64b3911d507affe524e9c18a3a467f"
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
          size      = 160
        }
      ]
    }
    "192.168.1.36" = {
      node                = "epsilon"
      cores               = 4
      memory              = 8196
      boot_disk_size      = 40
      boot_disk_datastore = "samsung-ssd"
      extra_disks = [
        {
          datastore = "nvme-ssd"
          size      = 160
        }
      ]
    }
    "192.168.1.37" = {
      node                = "epsilon"
      cores               = 4
      memory              = 8196
      boot_disk_size      = 40
      boot_disk_datastore = "samsung-ssd"
      extra_disks = [
        {
          datastore = "nvme-ssd"
          size      = 160
        }
      ]
    }
  }
}
