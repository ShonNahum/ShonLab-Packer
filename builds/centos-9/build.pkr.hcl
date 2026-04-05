build {
  name    = "centos-9"
  sources = ["source.proxmox-clone.base"]

  provisioner "shell" {
    script = "../../scripts/install-common-rpm.sh"
  }

  provisioner "shell" {
    script = "scripts/install-centos.sh"
  }

  provisioner "shell" {
    script = "../../scripts/base-cleanup.sh"
  }
}
