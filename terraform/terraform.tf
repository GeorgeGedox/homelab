terraform {
  required_version = "~> 1.9"

  cloud {
    organization = "georgev"

    workspaces {
      name = "homelab"
    }
  }

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.77.0"
    }

    sops = {
      source  = "carlpett/sops"
      version = "~> 1.1"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "0.7.1"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
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
