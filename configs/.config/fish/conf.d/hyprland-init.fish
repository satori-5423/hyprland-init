# --- path ---
fish_add_path ~/.local/bin

# --- variables ---
if test -f ~/.config/user-dirs.dirs
    for line in (string match -r '^XDG_.*' < ~/.config/user-dirs.dirs)
        set -l key (string replace -r '^([^=]+)=.*' '$1' -- $line)
        set -l val (string replace -r '^[^=]+="(.*)"' '$1' -- $line | string replace '$HOME' $HOME)
        set -gx $key $val
    end
end

# --- alias ---
alias vi nvim
alias vim nvim
alias nano nvim
alias tree 'eza --icons --tree'

# --- source ---
source ~/.config/fish/auto-Hypr.fish
direnv hook fish | source
