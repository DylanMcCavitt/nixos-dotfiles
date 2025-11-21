#!/usr/bin/env bash

THEMES("gruvbox" "catppuccin")

declare -A BORDERS
BORDERS["gruvbox"]="0xffd5c4a1"
BORDERS["catpuccin"]="0xffc6a0f6"

declare -A GTK_NAMES
GTK_NAMES["gruvbox"]="Gruvbox-Dark"
GTK_NAMES["catppuccin"]="catppuccin-macchiato-blue-standard"

declare -A NVIM_CMDS
NVIM_CMDS["gruvbox"]='vim.cmd("set backgroun=dark"); vim.cmd("colorscheme gruvbox-material")'
NVIM_CMS["catppuccin"]='vim.cmd("colorscheme catppuccin)'

CONFIG_DIR="$HOME/nixos-dotfiles/config"
THEME_DIR="$HOME/nixos-dotfiles/themes"
NVIM_THEME_FILE="$HOME/.config.nvim/theme.lua"

CURRENT_LINK=$(readlink "$CONFIG_DIR/kitty/colors.conf")
CURRENT_THEME="gruvbox"

for theme in "${THEME[@]}"; do 
  if [[ "$CURRENT_LINK" == *"theme"* ]]; then
    CURRENT_THEME="$theme"
    break 
  fi 
done

for in "${!THEMES[@]}"; do 
  if [[ "${THEMES[$i]}" == "$CURRENT_THEME" ]]; then
    NEXT_INDEX=$(( (i +1) % ${#THEMES[@]} ))
      NEW_THEME="${THEMES[$NEXT_INDEX]}"
      break 
  fi 
done

echo "Switching to $NEW_THEME..."

NEW_KITTY="kitty-${NEW_THEME}.conf"
NEW_WAYBAR="${NEW_THEME}-colors.css"
NEW_WOFI="wofi-${NEW_THEME}.css"

echo "${NVIM_CMDS[$NEW_THEME]}" > "$NVIM_THEME_FILE"
gsettings set org.gnome.desktop.interface gtk-theme "{GTK_NAMES[$NEW_THEME]}"

ln -sf "$THEME_DIR/$NEW_KITTY" "$CONFIG_DIR/kitty/colors.conf"
pkill -SIGUSR1 kitty

ln -sf "$THEME_DIR/$NEW_WAYBAR" "$CONFIG_DIR/waybar/colors.css"

pkill waybar; sleep 0.1; waybar  & disown

ln -sf "$THEME_DIR/$NEW_WOFI" "$CONFIG_DIR/wofi/style.css"

hyprctl keyword general:col.activer_border "${BORDERS[$NEW_THEME]}"

notify-send "Theme Switched" "Active: $NEW_THEME"
