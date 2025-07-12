# Knee's Dotfiles Installer

⚠️ **WARNING: This is a personal dotfiles installer!** ⚠️

This repository contains my personal dotfiles and configuration setup. It is tailored specifically for my workflow, preferences, and system. **Use at your own risk** - installing these dotfiles may overwrite your existing configurations. ***Below you can read about configurations you may want to change, since they are tailored to me.***

## Overview

This installer gives you a niri installation with rofi as the launcher, mako as the notif daemon, mostly gnome system apps, and generally a gruvbox theme with some exceptions.

## Prerequisites

before downloading and using the installer you will need

- git
- fish

## Installation

to install use
```
git clone https://github.com/HumpityDumpityDumber/knees-dots-installer.git
```
**make sure /home/{your_user} is the current working directory (this can be checked by running `pwd`)

## What's Included

These dotfiles include

- equibop
- fastfetch
- fish (gruv colors, and an opening animation using sttt configured to work with kitty)
- kitty (gruv theme)
- mako (simple blue gruv theme)
- niri (mostly gradients, easy to pop out of this repo with no harm other than dependencies. these can be found within the keybinds and startup if you wish to download/replace them.)
- rofi (gruv theme with credits within the file)
- swayidle (simple locking with swaylock)
- swaylock-effects (gruv themed)
- waybar (semi gruv themed blue waybar)
- xdg-desktop-portal (this is just to make sure you are using xdg-desktop-portal-gnome)
- starship (tree)

You also get Google Sans Flex edited to just be rounded patched by me and [@twigform](https://github.com/twigform)!

## !! What to change !!

There are many places where you may want to change the configuration where it is specific to my system. These will be listed below:

## Troubleshooting

There might be problems with the **xwayland display** and **wayland display** so try setting those to `WAYLAND_DISPLAY "wayland-1"` and `DISPLAY ":0"` respectively in the niri config (`config.kdl` in the `env{}` section)

## License

My dotfiles are under the unlicense (yeah just do whatever)
