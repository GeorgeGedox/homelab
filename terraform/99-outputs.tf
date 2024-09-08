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
