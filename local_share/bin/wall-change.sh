#!/usr/bin/env bash

# ==============================================================================
# Sequential Wallpaper Selector with Random Transitions for awww
# ==============================================================================

WALLPAPER_DIR="$HOME/Pictures/Wallpapers/rose-pine/"
STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/awww_state"

# 1. Verification checks
if ! command -v awww &>/dev/null; then
  echo "Error: 'awww' is not installed or not in PATH." >&2
  exit 1
fi

if [[ ! -d "$WALLPAPER_DIR" ]]; then
  echo "Error: Directory '$WALLPAPER_DIR' does not exist." >&2
  exit 1
fi

# Ensure awww daemon is running
if ! pgrep -x "awww-daemon" &>/dev/null; then
  awww-daemon &
  sleep 0.5
fi

# 2. Collect and sort wallpapers alphabetically
readarray -t WALLPAPERS < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

TOTAL_WALLPAPERS=${#WALLPAPERS[@]}

if [[ $TOTAL_WALLPAPERS -eq 0 ]]; then
  echo "Error: No wallpapers found in '$WALLPAPER_DIR'." >&2
  exit 1
fi

# 3. Read previous state (Last index used and last transition)
LAST_INDEX=-1
LAST_TRANS=""

if [[ -f "$STATE_FILE" ]]; then
  mapfile -t STATE <"$STATE_FILE"
  LAST_INDEX="${STATE[0]:--1}"
  LAST_TRANS="${STATE[1]:-""}"
fi

# 4. Calculate next wallpaper index sequentially
NEXT_INDEX=$(((LAST_INDEX + 1) % TOTAL_WALLPAPERS))
NEXT_WALLPAPER="${WALLPAPERS[$NEXT_INDEX]}"

# 5. Select a random transition (Avoiding immediate repeat)
TRANSITIONS=("outer" "center" "any" "wipe" "wave" "grow" "simple")

RANDOM_TRANSITION="$LAST_TRANS"
while [[ "$RANDOM_TRANSITION" == "$LAST_TRANS" ]]; do
  RANDOM_TRANSITION="${TRANSITIONS[RANDOM % ${#TRANSITIONS[@]}]}"
done

# 6. Save current state for next execution
printf "%s\n%s\n" "$NEXT_INDEX" "$RANDOM_TRANSITION" >"$STATE_FILE"

# 7. Apply the wallpaper
awww img "$NEXT_WALLPAPER" \
  --transition-type "$RANDOM_TRANSITION" \
  --transition-step 90 \
  --transition-fps 60

echo "Applied [$((NEXT_INDEX + 1))/$TOTAL_WALLPAPERS]: $(basename "$NEXT_WALLPAPER") [Transition: $RANDOM_TRANSITION]"
