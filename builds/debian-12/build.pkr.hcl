build {
  name    = "debian-12"
  sources = ["source.proxmox-clone.base"]

  provisioner "shell" {
    script = "../../scripts/install-common.sh"
  }

  provisioner "shell" {
    script = "scripts/install-debian.sh"
  }

  provisioner "shell" {
    script = "../../scripts/base-cleanup.sh"
  }
}