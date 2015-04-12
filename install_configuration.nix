{ config, pkgs, ... }:

{
  imports = [ <nixos/modules/installer/cd-dvd/installation-cd-graphical.nix> ];
  boot.supportedFilesystems = [ "zfs" ];
}