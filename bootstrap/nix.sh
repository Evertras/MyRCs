#!/bin/bash

# This contains the very few procedural steps that should ever be done
# as part of a NixOS install.  Basically, I'm too paranoid to put even
# my password hash in git, so bootstrap the password and call it a day.

if [ ! -f "/etc/nixos/passwords/evertras" ]; then
  sudo mkdir -p /etc/nixos/passwords/
  while [ "${password}" != "${password_confirm}" ] && [ -n "${password}" ]; do
    read -s -p "Set evertras password: " password
    echo ""
    read -s -p "Confirm evertras password: " password_confirm
    echo ""
  done
  mkpasswd "${password}" | sudo tee /etc/nixos/passwords/evertras
  sudo chmod 0600 /etc/nixos/passwords/evertras
fi
