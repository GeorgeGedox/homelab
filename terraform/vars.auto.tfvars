cluster_data = {
  name = "homelab"
}

talos_image = {
  version           = "v1.9.3"
  arch              = "amd64"
  platform          = "nocloud"
  proxmox_datastore = "nas-tank"
  proxmox_node      = "epsilon"
  # customization:
  #   systemExtensions:
  #       officialExtensions:
  #           - siderolabs/amd-ucode
  #           - siderolabs/iscsi-tools
  #           - siderolabs/qemu-guest-agent
  #           - siderolabs/util-linux-tools
  schematic_id      = "2d9d79fe710caccded6d4b221e24a5e8316073f66b3061b6f2c49de07684c812"
}

vm_data = {
  network_gateway      = "192.168.0.1"
  network_subnet_range = 23
  starting_vmid        = 600
  cloud_init_datastore = "local-lvm"
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
      extra_disks = []
    }
    "192.168.1.36" = {
      node                = "epsilon"
      cores               = 4
      memory              = 8196
      boot_disk_size      = 40
      boot_disk_datastore = "samsung-ssd"
      extra_disks = []
    }
  }
  storage = {
    "192.168.1.40" = {
      node                = "epsilon"
      cores               = 4
      memory              = 8196
      boot_disk_size      = 40
      boot_disk_datastore = "samsung-ssd"
      extra_disks = [
        {
          datastore = "nvme-ssd"
          size      = 250
        }
      ]
    }
  }
}
