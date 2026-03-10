variable "proxmox_url"      { type = string }
variable "proxmox_username" { type = string; default = "root@pam" }
variable "proxmox_password" { type = string; sensitive = true }
variable "proxmox_node"     { type = string; default = "pve" }

variable "seed_vm_id"    { type = number; default = 8999 }
variable "template_id"   { type = number; default = 9000 }
variable "template_name" { type = string; default = "ubuntu-22.04-cloud" }
variable "storage"       { type = string; default = "local-lvm" }
variable "bridge"        { type = string; default = "vmbr0" }
variable "cpu_cores"     { type = number; default = 2 }
variable "memory"        { type = number; default = 2048 }
variable "disk_size"     { type = string; default = "20G" }
variable "ssh_username"  { type = string; default = "shon" }
variable "ssh_password"  { type = string; sensitive = true; default = "ubuntu" }
variable "ssh_timeout"   { type = string; default = "20m" }