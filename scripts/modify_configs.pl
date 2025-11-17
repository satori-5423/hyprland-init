#!/usr/bin/env perl

use strict;
use warnings;

my $file = shift or die "Usage: $0 <file>\n";

local @ARGV = ($file);
local $^I = '.bak';

while (<>) {
    modify_cursor($_) if $file =~ /execs\.conf$/;
    modify_file_manager($_) if $file =~ /keybinds\.conf$/;
    modify_zeditor($_) if $file =~ /keybinds\.conf$/;

    print;
}

# cursor
sub modify_cursor {
    my ($line) = @_;
    if ($line =~ /exec-once\s*=\s*hyprctl\s+setcursor/) {
        $line =~ s/Bibata-Modern-Classic/Bibata-Modern-Ice/;
    }
}

# nautilus
sub modify_file_manager {
    my ($line) = @_;
    if ($line =~ /bind\s*=\s*Super,\s*E,.*launch_first_available\.sh/) {
        if ($line =~ /"dolphin"\s+"nautilus"/) {
            $line =~ s/"dolphin"/"__TEMP__"/;
            $line =~ s/"nautilus"/"dolphin"/;
            $line =~ s/"__TEMP__"/"nautilus"/;
        }
    }
}

# zeditor
sub modify_zeditor {
    my ($line) = @_;
    if ($line =~ /bind\s*=\s*Super,\s*X,.*launch_first_available\.sh/) {
        if ($line !~ /"zeditor"/) {
            $line =~ s/(launch_first_available\.sh\s*)/$1 . "\"zeditor\" " /e;
        }
    }
}
