build {
  name    = "ubuntu-22.04"
  sources = ["source.proxmox-clone.base"]

  provisioner "shell" {
    script = "../../scripts/install-common.sh"
  }

  provisioner "shell" {
    script = "scripts/install-ubuntu.sh"
  }

  provisioner "shell" {
    script = "../../scripts/base-cleanup.sh"
  }
}