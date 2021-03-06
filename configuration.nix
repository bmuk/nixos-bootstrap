{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan
      ./hardware-configuration.nix
      ./hostname.nix
    ];

  # Usual grub stuff and enabling zfs support
  boot = {
    kernelModules = [ "batman-adv" ];
    loader.grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";
    };
    supportedFilesystems = [ "zfs" ];
  };

  # hostname gets defined by the install script
  # need them to respond to pings to know they are on when the lid is closed
  networking = {
    networkmanager.enable = true;
    firewall.allowPing = true;
  };

  # Eastern time
  time.timeZone = "America/New_York";

  # Builds all binaries in a chroot
  # this way we can be sure the resultant binaries don't
  # depend on anything outside of the Nix Store
  nix.useChroot = true;

  users = {
    mutableUsers = false;
    extraUsers.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbWaTXfa7ut/bXssVNa/6ujpkk9jlVpcjJqq7RFtJ7aeJEC3EV97V4WeyqE9CUj3C8GD5QwaBVih7FpWHkk9eLA55rNVmTs9VV+M7OHrbituMPs/JF9KOVRcyRasFWQc2+u4RnxxOShiTiNIE8irp/dTJKb4IdvLY3WLR6l3p7ph+QxAlf/LD9lhZTCHfL/1+AL6atM4OH5J4Zh7KINMCN4dnTgF0gRRlabdSRDA1WPT1o39qq3n+pd44FQ9+6ZHvjR6Zk+RPM8c6IlsRcgzjqqtwxudVOPUMJPlCsYc9Fk4Jx2zijkutLD0HVVYkVe/XNB0mgX5COx/gZhaDSnVlf student@thinkpad-1"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8G9a+UosREzrmLJJ6J8qkU4haB+hGcOhIoZoFLHQXVIUXtaO7eV0X/zfFL8I4gIJCuJdf1Sbb7ENMw1UReAhNTnLHNpobuTFUpJxmU1WZ8rtc90nF8jPxp6qFCvRmgwEfB5ZW752h9muEl7wuzTlGtAAECqprNzi81pKGS2FqXS1ygoLPTsp31TGPM9p0e+pAXpNGD3uODO/LbrSU+LpuxHPpHLHlU009YEGcn2WdWdEQJMgW3bu5PZ2L/q1uhPLkXDIPC08oH8FUOagevjFzpBk1VNJTpNigSXmN+GqcprgkMWyHgPqQieddnvp14XSCw3ZmHr4+A5iHjCMkB9o9 bmuk@crocodile"
    ];
    extraUsers.student = {
      isNormalUser = true;
      home = "/home/student";
      description = "Student";
      extraGroups = [ "wheel" "networkmanager" "dialout" ];
      password = "cybersecuritylab";
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbWaTXfa7ut/bXssVNa/6ujpkk9jlVpcjJqq7RFtJ7aeJEC3EV97V4WeyqE9CUj3C8GD5QwaBVih7FpWHkk9eLA55rNVmTs9VV+M7OHrbituMPs/JF9KOVRcyRasFWQc2+u4RnxxOShiTiNIE8irp/dTJKb4IdvLY3WLR6l3p7ph+QxAlf/LD9lhZTCHfL/1+AL6atM4OH5J4Zh7KINMCN4dnTgF0gRRlabdSRDA1WPT1o39qq3n+pd44FQ9+6ZHvjR6Zk+RPM8c6IlsRcgzjqqtwxudVOPUMJPlCsYc9Fk4Jx2zijkutLD0HVVYkVe/XNB0mgX5COx/gZhaDSnVlf student@thinkpad-1"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8G9a+UosREzrmLJJ6J8qkU4haB+hGcOhIoZoFLHQXVIUXtaO7eV0X/zfFL8I4gIJCuJdf1Sbb7ENMw1UReAhNTnLHNpobuTFUpJxmU1WZ8rtc90nF8jPxp6qFCvRmgwEfB5ZW752h9muEl7wuzTlGtAAECqprNzi81pKGS2FqXS1ygoLPTsp31TGPM9p0e+pAXpNGD3uODO/LbrSU+LpuxHPpHLHlU009YEGcn2WdWdEQJMgW3bu5PZ2L/q1uhPLkXDIPC08oH8FUOagevjFzpBk1VNJTpNigSXmN+GqcprgkMWyHgPqQieddnvp14XSCw3ZmHr4+A5iHjCMkB9o9 bmuk@crocodile"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    arduino
    batctl
    chromium
    erlang
    git
    linuxPackages.batman_adv
    mongodb
    nixops # only used by thinkpad-1 at this point
    python
  ];

  systemd.services.mesh = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = ''${pkgs.coreutils}/bin/touch /servicestarted'';
      ExecStop = ''${pkgs.coreutils}/bin/rm /servicestarted'';
    };
  };

  services = {
    openssh = {
      enable = true;
    };
    mongodb.enable = true;
    xserver = {
      enable = true;
      desktopManager = {
        xfce.enable = true;
        xterm.enable = false;
        default = "xfce";
      };
      synaptics = {
        enable = true;
        twoFingerScroll = true;
      };
    };
    # adds volume support (i.e. usb handling) to thunar
    udisks2.enable = true;
  };
}
