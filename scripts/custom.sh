#!/usr/bin/env bash

# files/extra
# ~/.config/fish/config.fish
# ~/.config/kitty/kitty.conf

KEYBINDS="$HOME/.config/hypr/hyprland/keybinds.conf"
EXECS="$HOME/.config/hypr/hyprland/execs.conf"

perl -i -pe '
    if (/exec-once\s*=\s*hyprctl\s+setcursor/) {
        s/Bibata-Modern-Classic/Bibata-Modern-Ice/;
    }
' "$EXECS"

perl -i -pe '
    if (/bind\s*=\s*Super,\s*E,.*launch_first_available\.sh/) {
        if (/"dolphin"\s+"nautilus"/) {
            s/"dolphin"/"__TEMP__"/;
            s/"nautilus"/"dolphin"/;
            s/"__TEMP__"/"nautilus"/;
        }
    }
' "$KEYBINDS"

perl -i -pe '
    if (/bind\s*=\s*Super,\s*X,.*launch_first_available\.sh/) {
        if (!/"zeditor"/) {
            s/(launch_first_available\.sh\s*)/"zeditor" /;
        }
    }
' "$KEYBINDS"

cp -v ./files/hyprland/* ~/.config/hypr/custom/
