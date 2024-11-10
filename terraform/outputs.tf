output "talosconfig" {
  value     = data.talos_client_configuration.cluster_config.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}

resource "local_sensitive_file" "kubeconfig" {
  depends_on = [talos_cluster_kubeconfig.this]

  content  = talos_cluster_kubeconfig.this.kubeconfig_raw
  filename = "${path.root}/../kubeconfig"
}

resource "local_sensitive_file" "talosconfig" {
  depends_on = [talos_cluster_kubeconfig.this]

  content  = data.talos_client_configuration.cluster_config.talos_config
  filename = "${path.root}/../talosconfig"
}

# resource "local_file" "talos_master_config" {
#   depends_on = [data.talos_machine_configuration.master]

#   content  = data.talos_machine_configuration.master.machine_configuration
#   filename = "${path.root}/../talos_cp_mc.yml"
# }

# resource "local_file" "talos_worker_config" {
#   depends_on = [data.talos_machine_configuration.worker]

#   content  = data.talos_machine_configuration.worker.machine_configuration
#   filename = "${path.root}/../talos_wk_mc.yml"
# }
