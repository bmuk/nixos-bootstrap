{ config, pkgs, ... }:

{
  imports = [ <nixos/modules/installer/cd-dvd/installation-cd-minimal.nix> ];
  boot.supportedFilesystems = [ "zfs" ];
}