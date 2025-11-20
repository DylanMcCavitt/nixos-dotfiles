# hosts/desktop/configuration.nix
{
  config,
  pkgs,
  pkgsUnstable,
  inputs,
  ...
}: {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ../../modules/system/secrets.nix
  ];

  users.users.dylan = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [tree];

    hashedPasswordFile = config.sops.secrets.user_password.path;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHE57f++Q9q9ltVxnohQNT5s6HXjupY66cUSgH+IfN5s dylan@dylan-desktop"
    ];
  };

  boot.kernelParams = ["nvidia-drm.modeset=1"];
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.getty.autologinUser = "dylan";

  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  networking.hostName = "dylan-desktop";

  networking.networkmanager.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    foot
    hyprpaper
    tree
  ];

  system.stateVersion = "25.05";
}
