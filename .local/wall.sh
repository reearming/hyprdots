#!/bin/bash

wallpaper="$1"

if [ -z "$wallpaper" ] || [ ! -f "$wallpaper" ]; then
    exit 1
fi

source_colors=$(
    matugen image \
        --show-source-colors \
        "$wallpaper"
)

count=$(
    printf '%s\n' "$source_colors" |
    grep -c '^#'
)

if [ "$count" -eq 0 ]; then
    exit 1
fi

source_index=$((RANDOM % count))

matugen image \
    --source-color-index "$source_index" \
    "$wallpaper" &&
awww img "$wallpaper" -t random &&
printf '%s\n' "$wallpaper" > "$HOME/.cache/current-wallpaper"
