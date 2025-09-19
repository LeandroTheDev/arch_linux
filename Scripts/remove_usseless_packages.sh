#!/bin/bash

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "No privileges..."
  exit 1
fi

# Confirmation prompt
read -rp "This will remove all usseless orphaned packages without confirmation. Do you want to continue? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 0
fi

while true; do
  # Get all packages that were installed as dependencies
  dependencies_packages=$(pacman -Qdq)

  removed=false

  # Iterate through all packages
  for package in $dependencies_packages; do
      if ! pacman -Rns --noconfirm "$package"; then
          echo "$package: ignoring..."
      else
          removed=true
      fi
  done

  if [[ "$removed" == false ]]; then
    echo "No packages were removed. Your pacman dependencies are clear."
    break
  fi
done

read -rp "This script probably deleted ca-certificates do you want to reinstall it? (Y/n): " confirm_cert
if [[ "$confirm_cert" =~ ^[Nn]$ ]]; then
    echo "Reinstalling ca-certificates..."
    sudo pacman -S --needed --noconfirm ca-certificates
    echo "Certificates reinstalled. HTTPS connections should now work."
else
    echo "Skipped reinstalling certificates. HTTPS may not work."
fi
