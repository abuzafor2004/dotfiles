#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status, 
# treat unset variables as an error, and catch errors in pipelines.
set -euo pipefail

# Color definitions for output logging
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Ensure script is not run as root directly (makepkg will fail as root anyway)
if [[ $EUID -eq 0 ]]; then
    error "Do not run this script as root/sudo directly. It will prompt for sudo when necessary."
    exit 1
fi

info "Updating system packages..."
sudo pacman -Syu --noconfirm

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
    wiremix awww cava yazi neovim thunar thunar-archive-plugin tumbler 
    gvfs gvfs-mtp rofi rofi-calc xdg-desktop-portal xdg-desktop-portal-gtk 
    xdg-desktop-portal-hyprland btop zip gzip unzip 7zip tar file-roller 
    zoxide fzf ripgrep fastfetch starship ttf-cascadia-code-nerd kitty 
    grim slurp qt5-wayland qt6-wayland qt5ct qt6ct imv polkit-gnome 
    nwg-look adw-gtk-theme papirus-icon-theme swaync timeshift flatpak 
    vlc vlc-plugins-all lutris pipewire pipewire-pulse pipewire-alsa 
    pipewire-jack wireplumber sddm openssh
)

info "Installing official repository packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"

# --- AUR Packages ---
AUR_PACKAGES=(
    helium-browser-bin
    waybar-git
    ab-download-manager-bin
    pamac-all
    rose-pine-cursor
    rose-pine-hyprcursor
)

info "Installing AUR packages via yay..."
yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

# --- Flatpak Applications ---
info "Configuring Flathub remote..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

FLATPAK_APPS=(
    io.github.kolunmi.Bazaar
    io.github.flattool.Warehouse
    com.github.tchx84.Flatseal
    com.dec05eba.gpu_screen_recorder
    com.github.wwmm.easyeffects
)

info "Installing Flatpak applications..."
flatpak install -y flathub "${FLATPAK_APPS[@]}" || info "Some flatpaks might already be installed."

# --- System Services ---
info "Enabling and starting system services..."
systemctl --user enable --now pipewire pipewire-pulse wireplumber
sudo systemctl enable --now sshd sddm

# --- Post-Install Verification ---
info "Verifying critical services..."
services=(sshd sddm pipewire)
for svc in "${services[@]}"; do
    if systemctl is-active --quiet "$svc" || systemctl --user is-active --quiet "$svc"; then
        success "Service '$svc' is active and running."
    else
        error "Service '$svc' failed to start properly."
    fi
done

success "Setup completed successfully! Please reboot your system."
