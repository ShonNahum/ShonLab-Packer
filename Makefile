ubuntu:
	cd builds/ubuntu-22.04 && packer build -var-file=ubuntu.pkrvars.hcl .

debian:
	cd builds/debian-12 && packer build -var-file=debian.pkrvars.hcl .