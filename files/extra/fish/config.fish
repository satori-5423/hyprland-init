# --- PATH ---
contains ~/.local/bin $fish_user_paths
or set -Ua fish_user_paths ~/.local/bin

# --- Editors ---
set -Ux EDITOR nvim
set -Ux VISUAL $EDITOR
