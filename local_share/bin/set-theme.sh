#!/usr/bin/env bash

THEME_FILE="$HOME/.config/nvim/theme.txt"

THEMES=(
  "rose-pine" "rose-pine-main" "rose-pine-moon" "rose-pine-dawn"
  "catppuccin" "catppuccin-latte" "catppuccin-frappe" "catppuccin-macchiato" "catppuccin-mocha"
  "tokyonight" "tokyonight-night" "tokyonight-storm" "tokyonight-day" "tokyonight-moon"
  "gruvbox" "kanagawa" "kanagawa-wave" "kanagawa-dragon" "kanagawa-lotus"
  "nightfox" "nordfox" "duskfox" "onedark" "nord" "everforest" "PaperColor"
)

usage() {
  echo "Usage: $(basename "$0") <theme_name>"
  echo ""
  echo "Available themes:"
  printf "  - %s\n" "${THEMES[@]}"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

NEW_THEME="$1"

VALID=false
for t in "${THEMES[@]}"; do
  if [ "$t" == "$NEW_THEME" ]; then
    VALID=true
    break
  fi
done

if [ "$VALID" = false ]; then
  echo "Error: Unknown theme '$NEW_THEME'"
  usage
fi

# 1. Update theme text file
mkdir -p "$(dirname "$THEME_FILE")"
echo -n "$NEW_THEME" > "$THEME_FILE"

# 2. Targeted IPC update for Neovim instances only
SEARCH_PATHS=("${XDG_RUNTIME_DIR:-/run/user/$UID}" "${TMPDIR:-/tmp}")

for path in "${SEARCH_PATHS[@]}"; do
  if [ -d "$path" ]; then
    while IFS= read -r socket; do
      if [ -S "$socket" ]; then
        nvim --server "$socket" --remote-send "<Cmd>lua pcall(vim.cmd.colorscheme, '$NEW_THEME')<CR>" &>/dev/null
      fi
    done < <(find "$path" -maxdepth 3 -type s \( -name "nvim*" -o -name "*nvim*.sock" \) 2>/dev/null)
  fi
done

echo "Colorscheme updated to: $NEW_THEME"
