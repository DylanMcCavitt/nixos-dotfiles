# hosts/desktop/home.nix
{
  config,
  pkgs,
  pkgsUnstable,
  nix-colors,
  ...
}: {
  imports = [
    ../../modules/home/theme.nix
    ../../modules/home/common.nix
    ../../modules/home/nvf.nix
  ];

  my.theme.name = "gruvbox";
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo nixos btw";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#desktop";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };
}
