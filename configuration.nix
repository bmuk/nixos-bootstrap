{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan
      ./hardware-configuration.nix
    ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.supportedFilesystems = [ "zfs" ];
  networking.hostName = "crocodile";
  networking.wireless.enable = true;
}