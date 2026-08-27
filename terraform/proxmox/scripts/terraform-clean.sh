#!/bin/bash

set -e

DELETE_KEYS=false

# Parse optional arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --delete-keys)
            DELETE_KEYS=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--delete-keys]"
            exit 1
            ;;
    esac
done

echo "Cleaning Terraform files..."

rm -rf .terraform
rm -f terraform.tfstate
rm -f terraform.tfstate.backup
rm -rf terraform-plugin-proxmox.log

if [[ "$DELETE_KEYS" == true ]]; then
    echo "Deleting SSH keys..."

    rm -f keys/ansible_ed25519
    rm -f keys/ansible_ed25519.pub

    echo "SSH keys deleted."
fi

echo "Terraform cleanup complete."
echo "Run 'terraform init' before the next 'terraform apply'."