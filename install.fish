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
echo (set_color green)"Welcome to Knee's Dotfiles Installer!"(set_color normal)
echo (set_color green)"========================================"(set_color normal)
echo ""
sleep 2

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

echo (set_color blue)"This script will install various packages and configurations for your Arch Linux system."(set_color normal)
echo (set_color blue)"It will also set up a GRUB theme and an audio visualizer bar."(set_color normal)
# ask for user permission
if read_confirm
    echo (set_color green)"Continuing with the installation..."(set_color normal)
else
    echo (set_color red)"Installation aborted. Exiting..."(set_color normal)
    exit 0
end

# check if user is on Arch Linux
echo (set_color yellow)"Checking if you're on Arch Linux..."(set_color normal)
set os (grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
if string match -q '*Arch*' $os
    echo (set_color green)"You're on Arch Linux! Continuing with the installation..."(set_color normal)
else
    echo (set_color red)"This is not Arch Linux, installation aborted. Please run this script on Arch Linux."(set_color normal)
    exit 1
end

# configure pacman
echo (set_color yellow)"Configuring pacman..."(set_color normal)
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo sed -i 's/^#ILoveCandy/ILoveCandy/' /etc/pacman.conf
sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf

# update package databases
echo (set_color yellow)"Updating package databases..."(set_color normal)
sudo pacman -Sy

# install base-devel if not already installed
echo (set_color yellow)"Installing base-devel..."(set_color normal)
sudo pacman -S --needed --noconfirm base-devel git

# Install yay if not already installed
if not type -q yay
    echo (set_color yellow)"Installing yay AUR helper..."(set_color normal)
    git clone https://aur.archlinux.org/yay.git
    pushd yay
    makepkg -si --noconfirm
    popd
    rm -rf yay
else
    echo (set_color green)"yay is already installed, skipping..."(set_color normal)
end

# install packages from packages.json
echo (set_color yellow)"Installing packages from packages.json..."(set_color normal)
sudo pacman -S --noconfirm jq
set packages (jq -r '.[]' packages.json)
for package in $packages
    echo (set_color cyan)"Installing $package..."(set_color normal)
    yay -S --noconfirm --needed $package
    if test $status -ne 0
        echo (set_color red)"Failed to install $package, continuing..."(set_color normal)
    end
end

# install flatpaks
echo (set_color yellow)"Installing Flatpaks..."(set_color normal)
flatpak install --assumeyes flathub \
    org.kde.krita \
    org.gimp.GIMP \
    org.blender.Blender \
    com.visualstudio.code \
    com.obsproject.Studio \
    md.obsidian.Obsidian \
    one.ablaze.floorp \
    com.jeffser.Alpaca \
    info.cemu.Cemu \
    com.github.marhkb.Pods \
    im.riot.Riot \
    org.prismlauncher.PrismLauncher \
    io.mrarm.mcpelauncher \

# installing spotify
echo (set_color yellow)"Installing Spotify..."(set_color normal)
flatpak install --assumeyes flathub com.spotify.Client

# patching spotify with spicetify
echo (set_color yellow)"Patching Spotify with Spicetify..."(set_color normal)

# clone spicetify-arch-installation-guide repository
echo (set_color cyan)"Downloading Spicetify Patching Script..."(set_color normal)
git clone --depth 1 https://github.com/boudywho/spicetify-arch-installation-guide.git $HOME/spicetify-arch-installation-guide

# run spicetify install script
echo (set_color cyan)"Patching Spotify with Spicetify..."(set_color normal)
cd $HOME/spicetify-arch-installation-guide
chmod +x spicetify.sh
./spicetify.sh

# download grub theme
echo (set_color yellow)"Downloading GRUB theme..."(set_color normal)
sudo git clone --depth 1 https://github.com/13atm01/GRUB-Theme.git "/opt/GRUB-Theme/"
sudo mv "/opt/GRUB-Theme/Inoue Takina" /opt/GRUB-Theme/Inoue-Takina

# install grub theme
echo (set_color yellow)"Installing GRUB theme..."(set_color normal)
cd "/opt/GRUB-Theme/Inoue-Takina"
sudo chmod +x install.sh
sudo ./install.sh

# update grub config
echo (set_color yellow)"Updating GRUB configuration..."(set_color normal)
sudo grub-mkconfig -o /boot/grub/grub.cfg

# download audio visualizer bar
echo (set_color yellow)"Downloading Knee's audio visualizer bar..."(set_color normal)
git clone --depth 1 https://github.com/HumpityDumpityDumber/python-bar-rewrite.git "/opt/python-bar-rewrite/"

# install audio visualizer bar
echo (set_color yellow)"Installing Knee's audio visualizer bar..."(set_color normal)
cd /opt/python-bar-rewrite/
sudo meson setup build --wipe
sudo meson install -C build

# copy configs to config folder (niri, equibop, etc.)
echo (set_color yellow)"Copying configuration files..."(set_color normal)
mkdir -p ~/.config
cp -r "$SCRIPT_DIR/.config/"* $HOME/.config/

# set perms for niri scripts
echo (set_color yellow)"Setting permissions for niri scripts..."(set_color normal)
chmod +x $HOME/.config/niri/scripts/*

# configure plymouth
echo (set_color yellow)"Configuring Plymouth..."(set_color normal)

# Insert ShowDelay=0 after [Daemon] in the Plymouth config
sudo sed -i '/^\[Daemon\]/a ShowDelay=0' /etc/plymouth/plymouthd.conf

# Append 'plymouth' to the HOOKS line in mkinitcpio.conf, if not already present
if not grep -q 'plymouth' /etc/mkinitcpio.conf
    sudo sed -i 's/^\(HOOKS=.*\))$/\1 plymouth)/' /etc/mkinitcpio.conf
end

# Set and rebuild the default Plymouth theme
sudo plymouth-set-default-theme -R bgrt

# set fish as default shell
echo (set_color yellow)"Setting Fish as the default shell..."(set_color normal)
chsh -s (which fish)

# copy fonts into font folder
echo (set_color yellow)"Copying fonts to the font folder..."(set_color normal)
mkdir -p $HOME/.local/share/fonts
cp -r "$SCRIPT_DIR/fonts/"* $HOME/.local/share/fonts/
fc-cache -fv

# clone gruvbox wallpapers
echo (set_color yellow)"Cloning Gruvbox wallpapers..."(set_color normal)
git clone --depth 1 https://github.com/AngelJumbo/gruvbox-wallpapers.git $HOME/Pictures/gruvpapers

# clean up
echo (set_color yellow)"Cleaning up..."(set_color normal)
rm -rf $HOME/spicetify-arch-installation-guide/
sudo rm -rf /opt/GRUB-Theme/
sudo rm -rf /opt/python-bar-rewrite/
yay -Yc --noconfirm
sudo pacman -Sc --noconfirm

echo (set_color green)"Installation completed successfully!"(set_color normal)

echo (set_color blue)"run 'nerdfonts-installer' to install Nerd Fonts. (it isnt run automatically because it takes a long time to install)"(set_color normal)

echo (set_color blue)"Rebooting your system is recommended to apply all changes successfully."(set_color normal)

if read_confirm   
    echo (set_color green)"Rebooting your system..."(set_color normal)
    sudo reboot
else
    echo (set_color yellow)"You can reboot later to apply the changes."(set_color normal)
end
