# ShonLab-Packer

Modular Packer project that builds VM templates on Proxmox.
Add a new OS by adding one folder under `builds/`.

---

## Project Structure
```
ShonLab-Packer/
│
├── scripts/                        ← shared across ALL builds
│   ├── install-common.sh           ← packages every APT-based VM gets
│   ├── install-common-rpm.sh       ← packages every DNF-based VM gets (CentOS/RHEL)
│   └── base-cleanup.sh             ← wipes machine-id, SSH keys, cloud-init state
│
├── builds/
│   ├── ubuntu-22.04/
│   │   ├── source.pkr.hcl
│   │   ├── build.pkr.hcl
│   │   ├── ubuntu.pkrvars.hcl.example
│   │   └── scripts/
│   │       └── install-ubuntu.sh
│   │
│   └── centos-9/
│       ├── source.pkr.hcl
│       ├── build.pkr.hcl
│       ├── centos.pkrvars.hcl.example
│       └── scripts/
│           └── install-centos.sh
│
└── setup/
    └── import-seed.sh              ← run ONCE on Proxmox
```

---

## How It Works
```
setup/import-seed.sh          ← run once on Proxmox
        │
        │ creates seed VM (raw cloud image)
        ▼
packer build .                ← run on your PC
        │
        ├── clones seed VM
        ├── boots it
        ├── SSHs in and runs:
        │     1. scripts/install-common.sh      (shared, APT)
        │        scripts/install-common-rpm.sh  (shared, DNF — for CentOS)
        │     2. scripts/install-<os>.sh        (os-specific)
        │     3. scripts/base-cleanup.sh        (shared)
        └── converts to Proxmox template
                │
                ▼
        terraform-infra clones this template for every VM
```

---

## Seed VM IDs

| OS               | Seed VM ID | Template ID |
|------------------|-----------|-------------|
| Ubuntu 22.04     | 8999      | 9000        |
| CentOS Stream 9  | 8998      | 9001        |

---

## Usage

### Step 1 — Create seed VM (once, on Proxmox server)
```bash
bash setup/import-seed.sh ubuntu   # Ubuntu only
bash setup/import-seed.sh centos   # CentOS only
bash setup/import-seed.sh all      # both
```

> ⚠️ After the seed VM boots, make sure `qemu-guest-agent` is installed and
> `ipconfig0=dhcp` is set in the Cloud-Init tab before converting to a template.

### Step 2 — Configure
```bash
# Ubuntu
cd builds/ubuntu-22.04
cp ubuntu.pkrvars.hcl.example ubuntu.pkrvars.hcl
nano ubuntu.pkrvars.hcl

# CentOS
cd builds/centos-9
cp centos.pkrvars.hcl.example centos.pkrvars.hcl
nano centos.pkrvars.hcl
```

### Step 3 — Build
```bash
# Ubuntu
cd builds/ubuntu-22.04
packer init .
packer build -var-file=ubuntu.pkrvars.hcl .

# CentOS
cd builds/centos-9
packer init .
packer build -var-file=centos.pkrvars.hcl .
```

### Rebuild after OS updates
```bash
# Ubuntu
qm destroy 9000 --purge
packer build -var-file=ubuntu.pkrvars.hcl .

# CentOS
qm destroy 9001 --purge
packer build -var-file=centos.pkrvars.hcl .
```

---

## OS Details

| OS              | Default SSH User | Package Manager | Seed Image                          |
|-----------------|-----------------|-----------------|-------------------------------------|
| Ubuntu 22.04    | `ubuntu`        | `apt`           | Ubuntu Jammy GenericCloud           |
| CentOS Stream 9 | `cloud-user`    | `dnf`           | CentOS Stream 9 GenericCloud        |

---

## Adding a New OS

```bash
# APT-based (Debian family)
cp -r builds/ubuntu-22.04 builds/debian-12

# DNF-based (RHEL family)
cp -r builds/centos-9 builds/rocky-9
```

Then update in the new folder:
- `template_id` → unique number (e.g. `9002`)
- `template_name` → e.g. `"rocky-9-cloud"`
- `seed_vm_id` → unique number (e.g. `8997`)
- `ssh_username` → distro's cloud default user

Replace the `scripts/install-<os>.sh` with your OS-specific packages.
Add the seed VM function to `setup/import-seed.sh`.

---

## Relationship to Other Projects
```
ShonLab-Packer    →   terraform-infra   →   ansible-config
builds templates      clones templates       configures VMs
                       creates VMs
```