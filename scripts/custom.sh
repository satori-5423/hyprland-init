#!/usr/bin/env bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# The parent directory of scripts/ is the root of the repo
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Exit on error
set -e

# Function to backup file
backup_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local backup="${file}.bak.$(date +%Y%m%d%H%M%S)"
        echo "Backing up $file to $backup"
        cp "$file" "$backup"
    fi
}

# --- Kitty Configuration Injection ---
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
KITTY_EXTRA="$REPO_ROOT/files/extra/kitty/kitty.conf"

if [[ -f "$KITTY_EXTRA" ]]; then
    echo "Injecting Kitty configuration..."
    mkdir -p "$(dirname "$KITTY_CONF")"
    backup_file "$KITTY_CONF"

    # Create a temporary file
    TEMP_KITTY=$(mktemp)
    
    # Add extra config first
    cat "$KITTY_EXTRA" > "$TEMP_KITTY"
    
    # Append existing config if it exists
    if [[ -f "$KITTY_CONF" ]]; then
        cat "$KITTY_CONF" >> "$TEMP_KITTY"
    fi
    
    # Move temp file to target
    mv "$TEMP_KITTY" "$KITTY_CONF"
    echo "Kitty configuration updated."
else
    echo "Warning: Kitty extra configuration not found at $KITTY_EXTRA"
fi

# --- Fish Configuration Injection ---
FISH_CONF="$HOME/.config/fish/config.fish"
FISH_EXTRA="$REPO_ROOT/files/extra/fish/config.fish"

if [[ -f "$FISH_EXTRA" ]]; then
    echo "Injecting Fish configuration..."
    mkdir -p "$(dirname "$FISH_CONF")"
    
    if [[ -f "$FISH_CONF" ]]; then
        backup_file "$FISH_CONF"
        
        # Extract parts from extra config
        # Assuming the structure: variables first, then source at the end
        # We'll read the file and separate the source line
        
        FISH_VARS=$(grep -v "source ~/.config/fish/auto-Hypr.fish" "$FISH_EXTRA")
        FISH_SOURCE=$(grep "source ~/.config/fish/auto-Hypr.fish" "$FISH_EXTRA")
        
        # Create temp file
        TEMP_FISH=$(mktemp)
        
        # Process line by line to find insertion point
        while IFS= read -r line; do
            echo "$line" >> "$TEMP_FISH"
            if [[ "$line" == *"if status is-interactive"* ]]; then
                echo "$FISH_VARS" >> "$TEMP_FISH"
            fi
        done < "$FISH_CONF"
        
        # Append source command to the end
        if [[ -n "$FISH_SOURCE" ]]; then
             echo "" >> "$TEMP_FISH"
             echo "$FISH_SOURCE" >> "$TEMP_FISH"
        fi
        
        mv "$TEMP_FISH" "$FISH_CONF"
        echo "Fish configuration updated."
    else
        echo "Warning: Target fish config not found at $FISH_CONF. Copying extra config directly."
        cp "$FISH_EXTRA" "$FISH_CONF"
    fi
else
    echo "Warning: Fish extra configuration not found at $FISH_EXTRA"
fi

cp -v "$REPO_ROOT/files/hyprland/"* ~/.config/hypr/custom/
