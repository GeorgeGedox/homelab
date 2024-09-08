resource "time_sleep" "delay_1m" {
  depends_on = [talos_machine_bootstrap.bootstrap]

  create_duration = "1m"
}

resource "helm_release" "cilium" {
  depends_on = [time_sleep.delay_1m, local_sensitive_file.kubeconfig]

  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.16.1"
  namespace  = "kube-system"

  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }

  set {
    name  = "kubeProxyReplacement"
    value = "true"
  }

  set_list {
    name  = "securityContext.capabilities.ciliumAgent"
    value = ["CHOWN", "KILL", "NET_ADMIN", "NET_RAW", "IPC_LOCK", "SYS_ADMIN", "SYS_RESOURCE", "DAC_OVERRIDE", "FOWNER", "SETGID", "SETUID"]
  }

  set_list {
    name  = "securityContext.capabilities.cleanCiliumState"
    value = ["NET_ADMIN", "SYS_ADMIN", "SYS_RESOURCE"]
  }

  set {
    name  = "cgroup.autoMount.enabled"
    value = "false"
  }

  set {
    name  = "cgroup.hostRoot"
    value = "/sys/fs/cgroup"
  }

  set {
    name  = "k8sServiceHost"
    value = "localhost"
  }

  set {
    name  = "k8sServicePort"
    value = "7445"
  }
}
