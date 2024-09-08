terraform {
  required_version = "~> 1.9"

  cloud {
    organization = "georgev"

    workspaces {
      name = "talos-cluster"
    }
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.63.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "~> 1.1"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.6.0-alpha.2"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.12.0"
    }
  }
}


data "sops_file" "secrets" {
  source_file = "secrets.sops.yml"
}

provider "proxmox" {
  endpoint = data.sops_file.secrets.data["proxmox_url"]
  username = data.sops_file.secrets.data["proxmox_username"]
  password = data.sops_file.secrets.data["proxmox_password"]
}

provider "helm" {
  kubernetes {
    config_path = "${path.root}/../kubeconfig"
  }
}
