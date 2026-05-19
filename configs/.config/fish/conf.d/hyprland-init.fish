# --- PATH ---
contains ~/.local/bin $fish_user_paths
or set -Ua fish_user_paths ~/.local/bin

alias vi nvim
alias vim nvim
alias tree 'eza --icons --tree'

source ~/.config/fish/auto-Hypr.fish
