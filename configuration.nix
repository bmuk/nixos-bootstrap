{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan
      ./hardware-configuration.nix
      ./hostname.nix
    ];

  # Usual grub stuff and enabling zfs support
  boot = {
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
    ];
    extraUsers.student = {
      isNormalUser = true;
      home = "/home/student";
      description = "Student";
      extraGroups = [ "wheel" "networkmanager" ];
      password = "cybersecuritylab";
      openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC096XtxBRaho/l72r/5zKKcbgj1GvyN6j3qm7lAclx3op5GPhfimWGLmTthdOB7jO9gTPgjz+q0uJI2NOHBzF59WxJOV/37lKzvzglHxDMaPkRgtpIVQi5O+BQpy8jvU5nWhJ/FKhqRYZHmfPUwm9GGc0eJAPwETjN3pZabN1V6nFZjjntwjN1Ml/8CrMPpxIKlQlBwuxDm2YznnHVBBNkel921+FBs+oTmCQSYR3ljJ1tzt35Mkt7btjMfqmFHUGbhumbN8mBPW5aj591nB25cw7IR4r7fj1rqiJqbBJ7RzJUea9H52R47tfvnSHH6hOp2B0G0NkdaCwnh1lx5YAD Britt@WIN-VG68FPVJEA1"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbWaTXfa7ut/bXssVNa/6ujpkk9jlVpcjJqq7RFtJ7aeJEC3EV97V4WeyqE9CUj3C8GD5QwaBVih7FpWHkk9eLA55rNVmTs9VV+M7OHrbituMPs/JF9KOVRcyRasFWQc2+u4RnxxOShiTiNIE8irp/dTJKb4IdvLY3WLR6l3p7ph+QxAlf/LD9lhZTCHfL/1+AL6atM4OH5J4Zh7KINMCN4dnTgF0gRRlabdSRDA1WPT1o39qq3n+pd44FQ9+6ZHvjR6Zk+RPM8c6IlsRcgzjqqtwxudVOPUMJPlCsYc9Fk4Jx2zijkutLD0HVVYkVe/XNB0mgX5COx/gZhaDSnVlf student@thinkpad-1"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    chromium
    erlang
    git
    nixops # only used by thinkpad-1 at this point
  ];

  services = {
    openssh = {
      enable = true;
    };
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
