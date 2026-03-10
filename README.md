# packer-proxmox

Modular Packer project that builds VM templates on Proxmox.
Add a new OS by adding one folder under `builds/`.

---

## Project Structure
```
packer-proxmox/
│
├── modules/
│   └── proxmox-base/
│       └── source.pkr.hcl     ← shared Proxmox source (connection, hardware)
│
├── scripts/                   ← shared across ALL OS builds
│   ├── install-common.sh      ← packages every VM gets
│   └── base-cleanup.sh        ← wipes machine-id, SSH keys, cloud-init state
│
├── builds/
│   ├── ubuntu-22.04/
│   │   ├── build.pkr.hcl
│   │   ├── variables.pkr.hcl
│   │   ├── ubuntu.pkrvars.hcl.example
│   │   └── scripts/
│   │       └── install-ubuntu.sh
│   │
│   └── debian-12/
│       ├── build.pkr.hcl
│       ├── variables.pkr.hcl
│       ├── debian.pkrvars.hcl.example
│       └── scripts/
│           └── install-debian.sh
│
└── setup/
    └── import-seed.sh         ← run ONCE on Proxmox
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
        │     1. scripts/install-common.sh   (shared)
        │     2. scripts/install-<os>.sh     (os-specific)
        │     3. scripts/base-cleanup.sh     (shared)
        └── converts to Proxmox template
                │
                ▼
        terraform-infra clones this template for every VM
```

---

## Usage

### Step 1 — Create seed VM (once, on Proxmox server)
```bash
bash setup/import-seed.sh ubuntu   # Ubuntu only
bash setup/import-seed.sh debian   # Debian only
bash setup/import-seed.sh all      # both
```

### Step 2 — Configure
```bash
cd builds/ubuntu-22.04
cp ubuntu.pkrvars.hcl.example ubuntu.pkrvars.hcl
nano ubuntu.pkrvars.hcl
```

### Step 3 — Build
```bash
cd builds/ubuntu-22.04
packer init ../../modules/proxmox-base/source.pkr.hcl
packer build -var-file=ubuntu.pkrvars.hcl .
```

### Rebuild after OS updates
```bash
qm destroy 9000 --purge
packer build -var-file=ubuntu.pkrvars.hcl .
```

---

## Adding a New OS
```bash
cp -r builds/ubuntu-22.04 builds/fedora-39
```

Then in `builds/fedora-39/variables.pkr.hcl` change:
- `template_id` → unique number e.g. `9002`
- `template_name` → `"fedora-39-cloud"`
- `seed_vm_id` → unique number e.g. `8997`
- `ssh_username` → whatever Fedora's default user is

Replace `scripts/install-ubuntu.sh` with your OS packages.
Add the seed VM to `setup/import-seed.sh`.

---

## Relationship to Other Projects
```
packer-proxmox    →   terraform-infra   →   ansible-config
builds templates      clones templates       configures VMs
                       creates VMs
```