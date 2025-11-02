#!/bin/bash

# Ensure root
if [[ $EUID -ne 0 ]]; then
  echo "No privileges..."
  exit 1
fi

# Confirm cleanup
read -rp "This will remove all useless orphaned packages without confirmation. Do you want to continue? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "Operation cancelled."
  exit 0
fi

# Main orphan removal loop
while true; do
  dependencies_packages=$(pacman -Qdtq) # Only orphaned deps
  if [[ -z "$dependencies_packages" ]]; then
    echo "No orphaned packages left. Dependencies are clean."
    break
  fi

  echo "Removing orphaned packages..."
  if ! pacman -Rns --noconfirm $dependencies_packages; then
    echo "Some packages could not be removed. Continuing..."
  fi
done

# Reinstall ca-certificates (often removed by mistake)
read -rp "Do you want to reinstall ca-certificates to ensure HTTPS works? (Y/n): " confirm_cert
if [[ ! "$confirm_cert" =~ ^[Nn]$ ]]; then
  echo "Reinstalling ca-certificates..."
  pacman -S --needed --noconfirm ca-certificates
  echo "Certificates reinstalled."
else
  echo "Skipped reinstalling certificates. HTTPS may not work."
fi

# Check for missing dependencies or broken packages
echo
echo "=== Checking for missing or broken dependencies... ==="
if pacman -Dk | grep -q "missing"; then
  echo "Broken dependencies detected. Attempting to fix..."
  missing_pkgs=$(pacman -Dk | grep "missing" | awk '{print $5}' | sort -u)
  if [[ -n "$missing_pkgs" ]]; then
    echo "Reinstalling missing packages: $missing_pkgs"
    pacman -S --needed --noconfirm $missing_pkgs
  fi
else
  echo "No broken dependencies found."
fi

# Reinstall all native packages to ensure system integrity
echo
read -rp "Do you want to verify and reinstall all native packages to ensure system integrity? (y/N): " confirm_repair
if [[ "$confirm_repair" =~ ^[Yy]$ ]]; then
  echo "Reinstalling all native packages..."
  pacman -Qnq | pacman -S --needed --noconfirm -
  echo "System reinstallation completed."
else
  echo "Skipped full system verification."
fi

echo
echo "Cleanup complete. Your system should now be consistent and all dependencies repaired."
