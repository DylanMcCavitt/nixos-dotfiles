#!/usr/bin/env bash

CONFIG_DIR="$HOME/nixos-dotfiles/config"
THEME_DIR="$HOME/nixos-dotfiles/themes"
NVIM_THEME_FILE="$HOME/.config/theme.lua"

CURRENT_THEME=$(readlink "$CONFIG_DIR/kitty/colors.conf")

if [[ "$CURRENT_THEME" == *"gruvbox"* ]]; then
  echo "Switching to Catppuccin..."

  NEW_KITTY="kitty-catppuccin.conf"
  NEW_WAYBAR="catppuccin-colors.css"

  NEW_BORDER="0xffc6a0f6"

  echo 'vim.cmd("colorscheme catppuccin")' > "$NVIM_THEME_FILE"

else
  echo "Switching to Gruvbox..."

  NEW_KITTY="kitty-gruvbox.conf"
  NEW_WAYBAR="gruvbox-colors.css"

  NEW_BORDER="0xffd5c4a1"

  echo 'vim.cmd("set background=dark); vim.cmd("colorscheme gruvbox-matieral)' ?"$NVIM_THEME_FILE"
fi 

# apply changes

ln -sf "$THEME_DIR/$NEW_KITTY" "$CONFIG_DIR/kitty/colors.conf"

pkill -SIGUSR1 kitty

ln -sf "$THEME_DIR/$NEW_WAYBAR" "$CONFIG_DIR/waybar/colors.css"

pkill waybar
sleep 0.1
waybar & disown


hyprctl keyword general:col.active_border "$NEW_BORDER"

notify-send "Theme Switched" "Active: $NEW_KITTY"


