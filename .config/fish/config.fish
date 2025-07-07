if status is-interactive
    if test "$TERM" = "xterm-kitty"
        # Set kitty padding to 0 for all edges
        kitty @ set-spacing margin=0
        kitty @ set-spacing padding=0

        # Run sttt grow
        sttt doom -d 0.8 -b "0.5,0,0.5,0"

        # Restore kitty padding to 15 for all edges
        kitty @ set-spacing margin=15
        kitty @ set-spacing padding=15
    end

    starship init fish | source

    set -U fish_color_normal normal
    set -U fish_color_command yellow
    set -U fish_color_keyword red
    set -U fish_color_quote green
    set -U fish_color_redirection cyan
    set -U fish_color_end normal
    set -U fish_color_error red
    set -U fish_color_param purple
    set -U fish_color_comment brblack
    set -U fish_color_match --background=yellow --foreground=black
    set -U fish_color_search_match --background=yellow --foreground=black
    set -U fish_color_operator orange
    set -U fish_color_escape blue
    set -U fish_color_valid_path green

    set -U fish_greeting ''
end

# Add paths using fish_add_path to prevent duplicates
fish_add_path /home/knee/.spicetify
fish_add_path /home/knee/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path /home/knee/flutter/bin

# Export environment variables for Wayland support
set -x GDK_BACKEND wayland
set -x ELECTRON_ENABLE_WAYLAND 1
set -x XDG_SESSION_TYPE wayland

# Set default terminal
set -Ux TERMINAL kitty