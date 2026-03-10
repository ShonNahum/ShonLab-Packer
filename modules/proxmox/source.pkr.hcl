packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.3"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_url"      { type = string }
variable "proxmox_username" { type = string; default = "root@pam" }
variable "proxmox_password" { type = string; sensitive = true }
variable "proxmox_node"     { type = string; default = "pve" }
variable "seed_vm_id"       { type = number }
variable "template_id"      { type = number }
variable "template_name"    { type = string }
variable "storage"          { type = string; default = "local-lvm" }
variable "bridge"           { type = string; default = "vmbr0" }
variable "cpu_cores"        { type = number; default = 2 }
variable "memory"           { type = number; default = 2048 }
variable "disk_size"        { type = string; default = "20G" }
variable "ssh_username"     { type = string; default = "shon" }
variable "ssh_password"     { type = string; sensitive = true; default = "packer" }
variable "ssh_timeout"      { type = string; default = "20m" }

source "proxmox-clone" "base" {
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_username
  password                 = var.proxmox_password
  insecure_skip_tls_verify = true
  node                     = var.proxmox_node

  clone_vm_id = var.seed_vm_id
  full_clone  = true

  vm_id   = var.template_id
  vm_name = var.template_name

  cores  = var.cpu_cores
  memory = var.memory
  os     = "l26"

  scsi_controller = "virtio-scsi-single"

  disks {
    disk_size    = var.disk_size
    storage_pool = var.storage
    type         = "scsi"
  }

  network_adapters {
    model  = "virtio"
    bridge = var.bridge
  }

  cloud_init              = true
  cloud_init_storage_pool = var.storage

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = var.ssh_timeout
}