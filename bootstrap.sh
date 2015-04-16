#!/usr/bin/env bash

# Save the old configuration
mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.old

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
mv /mnt/etc/nixos/configuration.nix /mnt/etc/nixos/configuration.nix.old
cp ./configuration.nix /mnt/etc/nixos/configuration.nix

# Install nixos
nixos-install

# Unmount everything
umount /mnt/home
umount /mnt/boot
umount /mnt
zfs umount -a

# reboot
reboot
