resource "talos_machine_secrets" "this" {
  talos_version = var.talos_image.version
}

data "talos_client_configuration" "cluster_config" {
  cluster_name         = var.cluster_data.name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [for ip, values in local._merged_node_definitions : ip]
  endpoints            = [for ip, values in local._merged_node_definitions : ip if values.type == "master"]
}

data "talos_machine_configuration" "this" {
  for_each         = local._merged_node_definitions
  cluster_name     = var.cluster_data.name
  machine_type     = each.value.type == "master" ? "controlplane" : "worker"
  talos_version    = var.talos_image.version
  cluster_endpoint = "https://${local._first_controlplane}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  config_patches = each.value.type == "master" ? concat(
    [for f in fileset(path.module, "patches/common/*.yaml") : file(f)],
    [for f in fileset(path.module, "patches/controlplane/*.yaml") : file(f)],
    [templatefile("${path.module}/patches/common/common.yaml.tftpl", {
      region    = var.cluster_data.proxmox_cluster_name
      node_name = each.value.node
    })]
    ) : concat(
    [for f in fileset(path.module, "patches/common/*.yaml") : file(f)],
    [for f in fileset(path.module, "patches/workers/*.yaml") : file(f)],
    [templatefile("${path.module}/patches/common/common.yaml.tftpl", {
      region    = var.cluster_data.proxmox_cluster_name
      node_name = each.value.node
    })]
  )
}

resource "talos_machine_configuration_apply" "this" {
  depends_on = [proxmox_virtual_environment_vm.cluster_vm]
  for_each   = local._merged_node_definitions

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.this[each.key].machine_configuration
  node                        = each.key
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on = [talos_machine_configuration_apply.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local._first_controlplane
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.bootstrap]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local._first_controlplane
}
