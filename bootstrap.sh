#!/usr/bin/env bash

# Get the laptop number to craft the hostname
read -p "Enter the laptop's number: " -e LAPTOP_NUMBER
HOSTNAME="\"thinkpad-$LAPTOP_NUMBER\""

# Create the nix file that specifies the hostname
HOSTNAME_FILE="{ config, pkgs, ... }:

{
  networking.hostName = $HOSTNAME;
}"
echo "$HOSTNAME_FILE" > ./hostname.nix

# Don't need the default config
rm /etc/nixos/configuration.nix

# Instate our new configuration (zfs)
cp ./install_configuration.nix /etc/nixos/configuration.nix
nixos-rebuild switch
modprobe zfs

# Partitioning (dirty fdisk echo magic)
(echo o; echo n; echo p; echo 1; echo; echo "+500MB"; echo t; echo be; echo a; echo n; echo p; echo 2; echo; echo; echo t; echo 2; echo bf; echo w) | fdisk /dev/sda

# ZFS Setup
zpool create -o ashift=12 -o altroot=/mnt -f rpool /dev/sda2
# Create Filesystems
zfs create -o mountpoint=none rpool/root
zfs create -o mountpoint=legacy rpool/root/nixos
zfs create -o mountpoint=legacy rpool/home
zfs set compression=lz4 rpool/home    # compress the home directories automatically

# Mount the filesystems manually
mount -t zfs rpool/root/nixos /mnt
# Home
mkdir -p /mnt/home
mount -t zfs rpool/home /mnt/home
# Boot
mkfs.ext4 -L boot -F /dev/sda1
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# Generate hardware config
nixos-generate-config --root /mnt

# Move the correct configuration into place
mv /mnt/etc/nixos/hardware-configuration.nix /tmp/hardware-configuration.nix
rm -rf /mnt/etc/nixos/
git clone https://github.com/bmuk/nixos-bootstrap /mnt/etc/nixos/
cp ./hostname.nix /mnt/etc/nixos/
mv /tmp/hardware-configuration.nix /mnt/etc/nixos/hardware-configuration.nix

# Install nixos
nixos-install

# Unmount everything
umount /mnt/home
umount /mnt/boot
umount /mnt
zfs umount -a

# reboot
reboot
