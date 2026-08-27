```markdown
# Proxmox Infrastructure

Terraform configuration for provisioning VMs on Proxmox.

## Prerequisites

- Terraform** v1.x
   - Terraform installed and available in `$PATH`.
- Proxmox VE** 9.x
   - Proxmox node/storage/network configuration available.
- Proxmox API access**
   - API user and token configured with the required privileges.
- Cloud-Init ready VM template**
   - A Rocky Linux Cloud-Init template configured and available to Terraform.
   - Template should have a bootable OS disk and Cloud-Init drive.
- Proxmox networking**
   - A Proxmox bridge/network configured for the VM deployment.
   - This project assumes the DevSecOps network uses the `10.10.10.0/24` subnet with `10.10.10.1` as the gateway.
   - Update the Terraform networking variables if your environment uses a different subnet, gateway, or bridge.
- SSH
   - `ssh-keygen` available on the system running the deployment scripts.
   - SSH keys are generated automatically by the deployment scripts when required. User also has the option to generate keys manually if desired.


### Install Terraform 

(macOS)
```bash
brew --version
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

(windows)
```powershell
# Using winget (Windows 10/11)
winget install HashiCorp.Terraform

# Or using Chocolatey
choco install terraform
```

(linux)
```bash
sudo apt update
sudo apt install -y gnupg software-properties-common wget

wget -O- https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install -y terraform
```

### Required Proxmox Privileges

Create a role (or use an existing one) with at least these privileges:

- `Datastore.AllocateSpace`
- `SDN.Use`
- `VM.Audit`
- `VM.Allocate`
- `VM.Config.CDROM`
- `VM.Config.CPU`
- `VM.Config.Cloudinit`
- `VM.Config.Disk`
- `VM.Config.Memory`
- `VM.Config.Network`
- `VM.Config.Options`
- `VM.Console`
- `VM.Clone`
- `VM.Config.HWType`
- `VM.Monitor`
- `VM.PowerMgmt`
- `Sys.Audit`

### Configuration

1. Copy the example variables file:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` for environment variables:

   - Proxmox node
   - Storage pool
   - Network bridge
   - VM template
   etc..


## Deployment Scripts

Scripts live in `./scripts`:

```bash
cd proxmox

chmod +x ./scripts/*
```

### Terraform Plan

```bash
./scripts/terraform-setup.sh
```

- Initializes Terraform
- Validates the Terraform configuration
- Generates a Terraform execution plan
- Does not make changes to the infrastructure
- Creates the ssh keys in /keys (private key is required but will need to be manually imported from the `/terraform/proxmox/keys` directory and placed in the bastion host .ssh directory as `ansible_ed25519`)

### Terraform Apply

```bash
./scripts/terraform-apply.sh
```

- Initializes Terraform
- Applies the Terraform configuration
- Provisions the VMs
- Injects the SSH public key into the VMs
- Prepares SSH access for Ansible configuration from the bastion


### Terraform Cleanup

```bash
./scripts/terraform-clean.sh
```

- Removes the `.terraform/` directory
- Removes `terraform.tfstate`
- Removes `terraform.tfstate.backup`
- Removes `terraform-plugin-proxmox.log`
- Does **not** delete SSH keys

### Terraform Cleanup + Delete SSH Keys

```bash
./scripts/terraform-clean.sh --delete-keys
```

- Performs all standard Terraform cleanup
- Deletes the generated SSH private key
- Deletes the generated SSH public key
- Allows the next deployment to generate a fresh SSH key pair