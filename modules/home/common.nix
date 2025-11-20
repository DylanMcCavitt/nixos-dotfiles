# modules/home/common.nix
{
  config,
  pkgs,
  pkgsUnstable,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    hypr = "hypr";
    kitty = "kitty";
    waybar = "waybar";
  };
in {
  programs.git = {
    enable = true;
    extraCOnfig.init.defaultBranch = "master";
  };
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";
  home.stateVersion = "25.05";

  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config.buffer_editor = "nvim"
    '';
  };

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  home.packages =
    (with pkgs; [
      waybar
      kitty
      neovim
      ripgrep
      nil
      nixpkgs-fmt
      nodejs
      gcc
      wofi
      nitch
      rofi
      btop
      wl-clipboard
      cliphist
    ])
    ++ (with pkgsUnstable; [
      go
      lazygit
    ]);

  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
    ];
  };

  services.ssh-agent.enable = true;
  xdg.enable = true;

  xdg.configFile =
    builtins.mapAttrs
    (_name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;
}
