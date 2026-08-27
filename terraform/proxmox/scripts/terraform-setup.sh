#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$SCRIPT_DIR/.."
KEY_DIR="$TERRAFORM_DIR/keys"

PRIVATE_KEY="$KEY_DIR/ansible_ed25519"
PUBLIC_KEY="$KEY_DIR/ansible_ed25519.pub"

mkdir -p "$KEY_DIR"

if [ ! -f "$PRIVATE_KEY" ]; then
    echo "SSH key not found. Generating new ED25519 key..."

    ssh-keygen -t ed25519 \
        -f "$PRIVATE_KEY" \
        -N "" \
        -C "ansible"
else
    echo "Existing SSH key found. Reusing key."
fi

chmod 600 "$PRIVATE_KEY"
chmod 644 "$PUBLIC_KEY"

cd "$TERRAFORM_DIR"

echo "Initializing Terraform..."
terraform init

echo "Generating Terraform plan..."
terraform plan