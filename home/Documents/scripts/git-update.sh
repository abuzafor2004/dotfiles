#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

echo "🔄 Pulling latest changes from GitHub (if any)..."
git pull origin main || true

echo "📂 Gathering latest configurations from system..."

# 1. Update ~/.config items
CONFIG_ITEMS=(btop cava gtk-3.0 gtk-4.0 hypr kitty nvim nwg-look qt5ct qt6ct rofi waybar yazi)
for item in "${CONFIG_ITEMS[@]}"; do
    if [[ -d "$HOME/.config/$item" ]]; then
        rm -rf "$DOTFILES_DIR/config/$item"
        cp -r "$HOME/.config/$item" "$DOTFILES_DIR/config/"
    fi
done

# 2. Update ~/.local/share items
LOCAL_ITEMS=(bin fonts icons themes)
for item in "${LOCAL_ITEMS[@]}"; do
    if [[ -e "$HOME/.local/share/$item" ]]; then
        rm -rf "$DOTFILES_DIR/local_share/$item"
        cp -r "$HOME/.local/share/$item" "$DOTFILES_DIR/local_share/"
    fi
done

# 3. Update Pictures, Documents, and .bashrc
cp -rf "$HOME/Pictures" "$DOTFILES_DIR/home/"
cp -rf "$HOME/Documents" "$DOTFILES_DIR/home/"
cp -f "$HOME/.bashrc" "$DOTFILES_DIR/home/"

echo "🚀 Pushing updates to GitHub..."
git add .
git commit -m "Auto-update dotfiles: $(date +%Y-%m-%d_%H:%M)" || echo "No changes to commit."
git push origin main

echo "✅ Dotfiles successfully updated and pushed!"
