#!/usr/bin/env bash

# Exit immediately on critical errors, but we handle package failures gracefully below
set -eo pipefail

# Color definitions for output logging
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[0;33m'
readonly NC='\033[0m' # No Color

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Ensure script is not run as root directly (makepkg will fail as root anyway)
if [[ $EUID -eq 0 ]]; then
    error "Do not run this script as root/sudo directly. It will prompt for sudo when necessary."
    exit 1
fi

info "Updating system packages..."
sudo pacman -Syu --noconfirm || warning "System update had minor issues, continuing..."

info "Installing base development tools and git..."
sudo pacman -S --needed --noconfirm base-devel git

# --- AUR Helper Setup (yay) ---
if ! command -v yay &> /dev/null; then
    info "Installing yay AUR helper..."
    WORK_DIR=$(mktemp -d)
    trap 'rm -rf "$WORK_DIR"' EXIT
    
    git clone https://aur.archlinux.org/yay.git "$WORK_DIR/yay"
    (
        cd "$WORK_DIR/yay"
        makepkg -si --noconfirm
    )
    success "yay installed successfully."
else
    info "yay is already installed. Skipping..."
fi

# --- Official Repositories Packages ---
PACMAN_PACKAGES=(
    wl-clipboard cliphist hyprland hypridle hyprlock hyprshot wiremix awww 
    cava yazi neovim thunar thunar-archive-plugin tumbler 
    gvfs gvfs-mtp rofi rofi-calc xdg-desktop-portal xdg-desktop-portal-gtk 
    xdg-desktop-portal-hyprland btop zip gzip unzip 7zip tar file-roller 
    zoxide fzf ripgrep fastfetch starship ttf-cascadia-code-nerd kitty 
    grim slurp qt5-wayland qt6-wayland qt5ct qt6ct imv polkit-gnome 
    nwg-look adw-gtk-theme papirus-icon-theme swaync timeshift flatpak 
    vlc vlc-plugins-all lutris pipewire pipewire-pulse pipewire-alsa 
    pipewire-jack wireplumber sddm openssh 
)

info "Installing official repository packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}" || warning "Some official packages failed to install, proceeding..."

# --- AUR Packages ---
AUR_PACKAGES=(
    helium-browser-bin
    waybar-git
    ab-download-manager-bin
    rose-pine-cursor
    rose-pine-hyprcursor
)

info "Installing AUR packages via yay (will skip individual failures if any)..."
for pkg in "${AUR_PACKAGES[@]}"; do
    yay -S --needed --noconfirm "$pkg" || warning "Failed to install AUR package: $pkg. Continuing..."
done

# --- Flatpak Applications ---
info "Configuring Flathub remote..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true

FLATPAK_APPS=(
    io.github.kolunmi.Bazaar
    io.github.flattool.Warehouse
    com.github.tchx84.Flatseal
    com.dec05eba.gpu_screen_recorder
    com.github.wwmm.easyeffects
)

info "Installing Flatpak applications..."
for app in "${FLATPAK_APPS[@]}"; do
    flatpak install -y flathub "$app" || warning "Failed to install Flatpak app: $app. Continuing..."
done

# --- Restore Dotfiles and Custom Assets from GitHub ---
info "Cloning and restoring dotfiles from GitHub..."
DOTFILES_DIR="$HOME/dotfiles"

if [[ ! -d "$DOTFILES_DIR" ]]; then
    git clone https://github.com/abuzafor2004/dotfiles.git "$DOTFILES_DIR" || error "Failed to clone dotfiles repository."
else
    info "Dotfiles directory already exists. Pulling latest updates..."
    git -C "$DOTFILES_DIR" pull || warning "Could not pull latest updates from remote repository."
fi

info "Restoring ~/.config directories..."
if [[ -d "$DOTFILES_DIR/config" ]]; then
    mkdir -p "$HOME/.config"
    cp -rf "$DOTFILES_DIR/config/"* "$HOME/.config/"
fi

info "Restoring ~/.local/share assets (fonts, icons, themes, bin)..."
if [[ -d "$DOTFILES_DIR/local_share" ]]; then
    mkdir -p "$HOME/.local/share"
    cp -rf "$DOTFILES_DIR/local_share/"* "$HOME/.local/share/"
fi

info "Restoring home files (Pictures, Documents, .bashrc)..."
if [[ -d "$DOTFILES_DIR/home" ]]; then
    [[ -f "$DOTFILES_DIR/home/.bashrc" ]] && cp -f "$DOTFILES_DIR/home/.bashrc" "$HOME/.bashrc"
    [[ -d "$DOTFILES_DIR/home/Pictures" ]] && cp -rf "$DOTFILES_DIR/home/Pictures" "$HOME/"
    [[ -d "$DOTFILES_DIR/home/Documents" ]] && cp -rf "$DOTFILES_DIR/home/Documents" "$HOME/"
fi
success "Dotfiles and assets restored successfully!"

# --- System Services ---
info "Enabling and starting system services..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber || warning "Could not enable user pipewire services."
sudo systemctl enable --now sshd sddm || warning "Could not enable core system services."

# --- Post-Install Verification ---
info "Verifying critical services..."
services=(sshd sddm pipewire)
for svc in "${services[@]}"; do
    if systemctl is-active --quiet "$svc" || systemctl --user is-active --quiet "$svc"; then
        success "Service '$svc' is active and running."
    else
        warning "Service '$svc' is not currently active (this might be normal if running inside a container or pre-reboot)."
    fi
done

success "Setup completed successfully!"

# --- Reboot Prompt (Default: Yes) ---
echo -e "${BLUE}[PROMPT]${NC}"
read -p "Would you like to reboot now? [Y/n] " -n 1 -r
echo
if [[ -z "$REPLY" || "$REPLY" =~ ^[Yy]$ ]]; then
    info "Initiating system reboot..."
    sudo reboot
else
    info "Reboot skipped. Please remember to restart your computer later for all services and drivers to take effect."
fi
