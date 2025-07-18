#!/usr/bin/env fish

# Store the script's starting directory
set SCRIPT_DIR (realpath (status --current-filename) | xargs dirname)

# intro screen
clear
echo (set_color cyan)"
██╗  ██╗███╗   ██╗███████╗███████╗███████╗    ██████╗  ██████╗ ████████╗███████╗
██║ ██╔╝████╗  ██║██╔════╝██╔════╝██╔════╝    ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
█████╔╝ ██╔██╗ ██║█████╗  █████╗  ███████╗    ██║  ██║██║   ██║   ██║   ███████╗
██╔═██╗ ██║╚██╗██║██╔══╝  ██╔══╝  ╚════██║    ██║  ██║██║   ██║   ██║   ╚════██║
██║  ██╗██║ ╚████║███████╗███████╗███████║    ██████╔╝╚██████╔╝   ██║   ███████║
╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝    ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝
                                                                                 
██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗          
██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗         
██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝         
██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗         
██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║         
╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝         
"(set_color normal)
sleep 1
echo (set_color green)"Welcome to Knee's Dotfiles Installer!"(set_color normal)
echo (set_color green)"========================================"(set_color normal)
echo ""
sleep 1

# ask for user permission func
function read_confirm
  while true
    read -l -P (set_color yellow)'Do you want to continue? [y/N] '(set_color normal) confirm

    switch $confirm
      case Y y
        return 0
      case '' N n
        return 1
    end
  end
end

# install packages from json array
function install_packages_from_json
    set category $argv[1]
    set packages (jq -r ".$category[]" packages.json)
    for package in $packages
        echo (set_color cyan)"Installing $package..."(set_color normal)
        sleep 1
        yay -S --noconfirm --needed $package
        if test $status -ne 0
            echo (set_color red)"Failed to install $package, continuing..."(set_color normal)
            sleep 1
        end
    end
end

# echo (set_color blue)"This script will install various packages and configurations for your Arch Linux system."(set_color normal)
# echo (set_color blue)"It will also set up a GRUB theme and an audio visualizer bar."(set_color normal)
sleep 1
# ask for user permission
if read_confirm
    echo (set_color green)"Continuing with the installation..."(set_color normal)
    sleep 1
else
    echo (set_color red)"Installation aborted. Exiting..."(set_color normal)
    sleep 1
    exit 0
end

# check if user is on Arch Linux
echo (set_color yellow)"Checking if you're on Arch Linux..."(set_color normal)
sleep 1
set os (grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
if string match -q '*Arch*' $os
    echo (set_color green)"You're on Arch Linux! Continuing with the installation..."(set_color normal)
    sleep 1
else
    echo (set_color red)"This is not Arch Linux, installation aborted. Please run this script on Arch Linux."(set_color normal)
    sleep 1
    exit 1
end

# configure pacman
echo (set_color yellow)"Configuring pacman..."(set_color normal)
sleep 1
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#ILoveCandy/ILoveCandy/' /etc/pacman.conf
sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf

# update package databases
echo (set_color yellow)"Updating package databases..."(set_color normal)
sleep 1
sudo pacman -Sy

# install base-devel if not already installed
echo (set_color yellow)"Installing base-devel..."(set_color normal)
sleep 1
sudo pacman -S --needed --noconfirm base-devel git

# Install yay if not already installed
if not type -q yay
    echo (set_color yellow)"Installing yay AUR helper..."(set_color normal)
    sleep 1
    git clone https://aur.archlinux.org/yay.git
    pushd yay
    makepkg -si --noconfirm
    popd
    rm -rf yay
else
    echo (set_color green)"yay is already installed, skipping..."(set_color normal)
    sleep 1
end

# install packages from packages.json
echo (set_color yellow)"Installing core packages from packages.json..."(set_color normal)
sleep 1
sudo pacman -S --noconfirm jq

# Install core packages
echo (set_color yellow)"Installing core packages..."(set_color normal)
install_packages_from_json core

# Ask for extra packages
set install_extra false
echo (set_color blue)"Extra packages include applications like Spotify, Obsidian, GIMP, Blender, and more."(set_color normal)
if read_confirm
    echo (set_color green)"Installing extra packages..."(set_color normal)
    set install_extra true
    install_packages_from_json extra
else
    echo (set_color yellow)"Skipping extra packages..."(set_color normal)
    sleep 1
end

# Ask for gaming packages
echo (set_color blue)"Gaming packages include Steam, Lutris, Wine, and various gaming libraries."(set_color normal)
if read_confirm
    echo (set_color green)"Installing gaming packages..."(set_color normal)
    install_packages_from_json gaming
else
    echo (set_color yellow)"Skipping gaming packages..."(set_color normal)
    sleep 1
end

# Ask for flatpaks
echo (set_color blue)"Flatpaks include OBS Studio, Alpaca, Pods, and Minecraft Launcher."(set_color normal)
if read_confirm
    echo (set_color yellow)"Installing Flatpaks..."(set_color normal)
    sleep 1
    flatpak install --assumeyes flathub \
        com.obsproject.Studio \
        com.jeffser.Alpaca \
        com.jeffser.Alpaca.Plugins.Ollama \
        com.github.marhkb.Pods \
        io.mrarm.mcpelauncher \
else
    echo (set_color yellow)"Skipping Flatpaks..."(set_color normal)
    sleep 1
end

# Install and configure spicetify only if extra packages were installed
if test $install_extra = true
    # install spicetify
    echo (set_color yellow)"Installing Spicetify CLI..."(set_color normal)
    sleep 1
    curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh

    # set permissions for spicetify
    echo (set_color yellow)"Setting permissions for Spicetify..."(set_color normal)
    sleep 1
    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R

    # patch spotify
    echo (set_color yellow)"Patching Spotify with Spicetify..."(set_color normal)
    sleep 1
    spicetify backup apply
end

# fixing micro
echo (set_color yellow)"Fixing Micro editor..."(set_color normal)
sleep 1
sudo ln -sf /usr/bin/kitty /usr/local/bin/xterm

# download grub theme
echo (set_color yellow)"Downloading GRUB theme..."(set_color normal)
sleep 1
sudo git clone --depth 1 https://github.com/13atm01/GRUB-Theme.git "/tmp/GRUB-Theme/"
sudo mv "/tmp/GRUB-Theme/Inoue Takina" /tmp/GRUB-Theme/Inoue-Takina

# install grub theme
echo (set_color yellow)"Installing GRUB theme..."(set_color normal)
sleep 1
cd "/tmp/GRUB-Theme/Inoue-Takina"
sudo chmod +x install.sh
sudo ./install.sh

# configure plymouth
echo (set_color yellow)"Configuring Plymouth..."(set_color normal)
sleep 1

# Insert ShowDelay=0 after [Daemon] in the Plymouth config
sudo sed -i '/^\[Daemon\]/a ShowDelay=0' /etc/plymouth/plymouthd.conf

# Append 'plymouth' to the HOOKS line in mkinitcpio.conf, if not already present
if not grep -q 'plymouth' /etc/mkinitcpio.conf
    sudo sed -i 's/^\(HOOKS=.*\))$/\1 plymouth)/' /etc/mkinitcpio.conf
end

# add splash to grub command
if not grep -q 'splash' /etc/default/grub
    sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="/&splash /' /etc/default/grub
end

# Set and rebuild the default Plymouth theme
sudo plymouth-set-default-theme -R bgrt

# update grub config
echo (set_color yellow)"Updating GRUB configuration..."(set_color normal)
sleep 1
sudo grub-mkconfig -o /boot/grub/grub.cfg

# download audio visualizer bar
echo (set_color yellow)"Downloading Knee's audio visualizer bar..."(set_color normal)
sleep 1
sudo git clone --depth 1 https://github.com/HumpityDumpityDumber/python-bar-rewrite.git "/opt/python-bar-rewrite/"

# install audio visualizer bar
echo (set_color yellow)"Installing Knee's audio visualizer bar..."(set_color normal)
sleep 1
cd /opt/python-bar-rewrite/
sudo meson setup build --wipe
sudo meson install -C build

# copy configs to config folder (niri, equibop, etc.)
echo (set_color yellow)"Copying configuration files..."(set_color normal)
sleep 1
mkdir -p ~/.config
cp -r "$SCRIPT_DIR/.config/"* $HOME/.config/

# set perms for niri scripts
echo (set_color yellow)"Setting permissions for niri scripts..."(set_color normal)
sleep 1
chmod +x $HOME/.config/niri/scripts/*

# enable and set GDM as display manager
echo (set_color yellow)"Enabling GDM display manager..."(set_color normal)
sleep 1
sudo systemctl enable gdm
sudo systemctl set-default graphical.target

# set fish as default shell
echo (set_color yellow)"Setting Fish as the default shell..."(set_color normal)
sleep 1
chsh -s (which fish)

# enable waybar and mako as services
echo (set_color yellow)"Enabling Waybar and Mako services..."(set_color normal
systemctl --user add-wants niri.service mako.service
systemctl --user add-wants niri.service waybar.service
systemctl --user enable ymako.service waybar.service

# copy fonts into font folder
echo (set_color yellow)"Copying fonts to the font folder..."(set_color normal)
sleep 1
mkdir -p $HOME/.local/share/fonts
cp -r "$SCRIPT_DIR/fonts/"* $HOME/.local/share/fonts/
fc-cache -fv

# fix gtk buttons
echo (set_color yellow)"Fixing GTK configuration..."(set_color normal)
sleep 1
gsettings set org.gnome.desktop.wm.preferences button-layout :
gsettings set org.gnome.desktop.interface icon-theme 'bloom'
gsettings set org.gnome.desktop.interface font-name 'Google Sans Rounded Bold 11'
gsettings set org.gnome.desktop.interface gtk-theme 'Gruvbox-Dark'
gsettings set org.gnome.desktop.interface cursor-theme 'gruvterial'

# clone gruvbox wallpapers
echo (set_color yellow)"Cloning Gruvbox wallpapers..."(set_color normal)
sleep 1
git clone --depth 1 https://github.com/AngelJumbo/gruvbox-wallpapers.git $HOME/Pictures/gruvpapers

# clean up
echo (set_color yellow)"Cleaning up..."(set_color normal)
sleep 1
sudo rm -rf /opt/GRUB-Theme/
sudo rm -rf /opt/python-bar-rewrite/
yay -Yc --noconfirm
sudo pacman -Sc --noconfirm

echo (set_color green)"Installation completed successfully!"(set_color normal)
sleep 1

echo (set_color blue)"do you want to run 'nerdfonts-installer'? Be aware that installing all nerd fonts takes a while!"(set_color normal)
sleep 1
if read_confirm
    echo (set_color green)"Running 'nerdfonts-installer'..."(set_color normal)
    sleep 1
    nerdfonts-installer
end

echo (set_color blue)"Rebooting your system is recommended to apply all changes successfully."(set_color normal)
sleep 1

if read_confirm   
    echo (set_color green)"Rebooting your system..."(set_color normal)
    sleep 1
    sudo reboot
else
    echo (set_color yellow)"You can reboot later to apply the changes."(set_color normal)
    sleep 1
end
echo (set_color blue)"Rebooting your system is recommended to apply all changes successfully."(set_color normal)
sleep 1

if read_confirm   
    echo (set_color green)"Rebooting your system..."(set_color normal)
    sleep 1
    sudo reboot
else
    echo (set_color yellow)"You can reboot later to apply the changes."(set_color normal)
    sleep 1
end
