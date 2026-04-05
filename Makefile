ubuntu:
	cd builds/ubuntu-22.04 && PACKER_LOG=1 packer build -var-file=ubuntu.pkrvars.hcl .

centos:
	cd builds/centos-9 && PACKER_LOG=1 packer build -var-file=centos.pkrvars.hcl .