# Knee's Dotfiles Installer

⚠️ **!! WARNING !! This is my personal dotfiles installer and not *fully* intended for public use!** ⚠️

This repository contains my personal dotfiles and configuration setup. It is tailored specifically for my workflow, preferences, and system. **Use at your own risk!** Installing these dotfiles will overwrite your existing config files for certain apps. The full list can be seen in the "Whats Included" section below. ***Below you can read about configurations you may want to change, since they are tailored to me.***

## Example

![Desktop Screenshot](https://github.com/HumpityDumpityDumber/knees-dots-installer/raw/main/example.png)
*Example desktop showing niri, with kitty and themed floorp open.*

## Overview

This installer gives you a niri installation with rofi as the launcher, mako as the notif daemon, mostly gnome system apps, and generally a gruvbox theme with some exceptions.

## Prerequisites

before downloading and using the installer you will need...

- git
- fish

## Installation

to download the repo use...
```
git clone --depth 1 https://github.com/HumpityDumpityDumber/knees-dots-installer.git
```
**make sure /home/{your_user} is the current working directory (this can be checked by running `pwd`)**

After cloning the repo into your home folder with the command above, the next step is running the following commands...
```
cd knees-dots-installer/
fish install.fish
```

optionally you could run `chmod +x ./install.fish` and then `./install.fish` to run, but that just adds an extra step :P
## What's Included

Many packages installed with `yay`! If you would like to see every package I would recommend taking a look at the `packages.json`. The packages aren't listed here for the sole reason of there are a lot of them :P

The dotfiles include...
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

There might be problems with the **xwayland display** and **wayland display** so try setting those to `WAYLAND_DISPLAY "wayland-0"` and `DISPLAY ":1"` respectively (this is usually only something  to consider when switching from gdm to sddm ive found) in the niri config (`config.kdl` in the `env{}` section)

## License

<a href="https://github.com/HumpityDumpityDumber/knees-dots-installer">knees-dotfiles-installer</a> © 2025 by <a href="https://github.com/HumpityDumpityDumber">knee</a> is licensed under <a href="https://creativecommons.org/licenses/by-sa/4.0/">CC BY-SA 4.0</a>
