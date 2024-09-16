resource "talos_machine_secrets" "this" {
  talos_version = var.talos_image.version
}

data "talos_client_configuration" "cluster_config" {
  cluster_name         = var.cluster_data.name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = [for ip, values in var.node_definition.masters : ip]
  endpoints            = [for ip, values in var.node_definition.masters : ip]
}

data "talos_machine_configuration" "master" {
  cluster_name     = var.cluster_data.name
  machine_type     = "controlplane"
  cluster_endpoint = "https://${local._first_controlplane}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_data.name
  machine_type     = "worker"
  cluster_endpoint = "https://${local._first_controlplane}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

resource "talos_machine_configuration_apply" "master" {
  depends_on = [proxmox_virtual_environment_vm.cluster_vm]
  for_each   = var.node_definition.masters

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.master.machine_configuration
  node                        = each.key

  config_patches = concat([for f in fileset(path.module, "patches/controlplane/*.yaml") : file(f)], [for f in fileset(path.module, "patches/common/*.yaml") : file(f)])
}

resource "talos_machine_configuration_apply" "worker" {
  depends_on = [proxmox_virtual_environment_vm.cluster_vm]
  for_each   = var.node_definition.workers

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = each.key

  config_patches = [for f in fileset(path.module, "patches/common/*.yaml") : file(f)]
}

resource "talos_machine_bootstrap" "bootstrap" {
  depends_on = [talos_machine_configuration_apply.master]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local._first_controlplane
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.bootstrap]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local._first_controlplane
}
