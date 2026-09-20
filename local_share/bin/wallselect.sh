#!/usr/bin/env bash

# Path to your wallpaper directory
WALL_DIR="$HOME/Pictures/Wallpapers/gruvbox/"

# Path to your wallselect.rasi theme file
ROFI_THEME="$HOME/.config/rofi/wallselect.rasi"

# Supported image formats
VALID_EXTENSIONS=("jpg" "jpeg" "png" "webp" "gif")

# Array of available awww transition types
TRANSITIONS=("wipe" "fade" "grow" "outer" "center" "any")

# Check if awww-daemon is running, start it if not
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 0.5
fi

# Build list of items with icons for Rofi
rofi_input=""
for ext in "${VALID_EXTENSIONS[@]}"; do
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            filename=$(basename "$file")
            rofi_input+="${filename}\0icon\x1f${file}\n"
        fi
    done < <(find "$WALL_DIR" -maxdepth 1 -type f -iname "*.${ext}")
done

# Show Rofi selection menu
SELECTION=$(echo -en "$rofi_input" | rofi -dmenu -theme "$ROFI_THEME" -p "Select Wallpaper")

# Apply selected wallpaper using awww with a random transition
if [[ -n "$SELECTION" ]]; then
    FULL_PATH="$WALL_DIR/$SELECTION"
    if [[ -f "$FULL_PATH" ]]; then
        RANDOM_TRANSITION="${TRANSITIONS[RANDOM % ${#TRANSITIONS[@]}]}"
        awww img "$FULL_PATH" --transition-type "$RANDOM_TRANSITION" --transition-duration 1
    fi
fi
