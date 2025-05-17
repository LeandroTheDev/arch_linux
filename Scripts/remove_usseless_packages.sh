#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "No privilegies..."
  exit 1
fi

while true; do
  # Get all packages that has been instaled without your consense
  dependencies_packages=$(pacman -Qdq)

  removed=false

  # Swiping all packages
  for package in $dependencies_packages; do
      if ! pacman -Rns --noconfirm "$package"; then
          echo "$package. ignoring..."
      else
          removed=true
      fi
  done

  if [[ "$removed" == false ]]; then
    echo "No packages was removed, your pacman dependency is clear"
    break
  fi
done
