resource "proxmox_virtual_environment_vm" "cluster_vm" {
  for_each = local._merged_node_definitions

  name            = "${var.cluster_data.name}-${coalesce(each.value.name, "${each.value.type}-${local._type_index_map[each.value.type][each.key]}")}"
  description     = coalesce(each.value.description, "Managed by Terraform")
  tags            = ["terraform", each.value.type, var.cluster_data.name, each.value.node]
  vm_id           = var.vm_data.starting_vmid + index(keys(local._merged_node_definitions), each.key)
  node_name       = each.value.node
  stop_on_destroy = true
  scsi_hardware   = "virtio-scsi-single"

  cpu {
    type         = "host"
    cores        = each.value.cores
    architecture = "x86_64"
  }

  memory {
    dedicated = each.value.memory
  }

  operating_system {
    type = "l26"
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    file_id      = proxmox_virtual_environment_download_file.talos_image.id
    file_format  = "raw"
    interface    = "scsi0"
    iothread     = true
    size         = each.value.boot_disk_size
    datastore_id = each.value.boot_disk_datastore
    ssd          = true
  }

  dynamic "disk" {
    for_each = each.value.extra_disks
    content {
      interface    = "scsi${disk.key + 1}"
      file_format  = "raw"
      iothread     = true
      size         = disk.value.size
      datastore_id = disk.value.datastore
      ssd          = true
    }
  }

  boot_order = ["scsi0"]

  initialization {
    datastore_id = var.vm_data.cloud_init_datastore
    ip_config {
      ipv4 {
        gateway = var.vm_data.network_gateway
        address = "${each.key}/${var.vm_data.network_subnet_range}"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      cpu["architecture"],
      disk[0].file_id
    ]
  }
}

resource "proxmox_virtual_environment_download_file" "talos_image" {
  content_type = "iso"
  node_name    = var.talos_image.proxmox_node
  datastore_id = var.talos_image.proxmox_datastore

  url                     = "https://factory.talos.dev/image/${var.talos_image.schematic_id}/${var.talos_image.version}/${var.talos_image.platform}-${var.talos_image.arch}.raw.gz"
  file_name               = "talos-${var.talos_image.version}-${var.talos_image.platform}-${var.talos_image.arch}.img"
  decompression_algorithm = "gz"
  overwrite               = false
}
