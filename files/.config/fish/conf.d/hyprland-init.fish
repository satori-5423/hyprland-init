# --- PATH ---
contains ~/.local/bin $fish_user_paths
or set -Ua fish_user_paths ~/.local/bin

alias vi nvim
alias vim nvim

# Auto start Hyprland on tty1
if test -z "$DISPLAY"; and test "$XDG_VTNR" -eq 1
    exec uwsm start hyprland.desktop
end

# source ~/.config/fish/auto-Hypr.fish
