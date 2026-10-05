# --- path ---
fish_add_path ~/.local/bin
fish_add_path $XDG_PROJECTS_DIR/GitHub/llama.cpp/build/bin

# --- variables ---
if test -f ~/.config/user-dirs.dirs
    for line in (string match -r '^XDG_.*' < ~/.config/user-dirs.dirs)
        set -l key (string replace -r '^([^=]+)=.*' '$1' -- $line)
        set -l val (string replace -r '^[^=]+="(.*)"' '$1' -- $line | string replace '$HOME' $HOME)
        set -gx $key $val
    end
end
set -gx LESS "-R -F -X"
set -gx MANOPT "-L C"
set -gx MANPAGER "nvim +Man! +'set statuscolumn='"

# --- alias ---
alias vi nvim
alias vim nvim
alias nano nvim
alias tree 'eza --icons --tree'

# --- functions ---
function ai --description "Switch llama-server"
    if systemctl --user is-active --quiet llama-server
        systemctl --user stop llama-server
        echo "llama-server stopped!"
    else
        systemctl --user start llama-server
        echo "llama-server started!"
    end
end

function stat --wraps stat
    if test "$argv[1]" = "/"
        command stat / | string replace -r '2025-12-01' '2024-11-28'
    else
        command stat $argv
    end
end

# --- source ---
source ~/.config/fish/auto-Hypr.fish
direnv hook fish | source
