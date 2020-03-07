#!/usr/bin/bash

if [ "$EUID" -eq 0 ]
  then echo "Do not run this script as root."
  exit
fi

echo "This script will prepare Surface devices for installation of a patched Arch Linux kernel."
echo "Answer 'y' to any options you wish to install. By default, options are unselected."
echo

cache_folder=.cache
patches_repository=git://github.com/linux-surface/linux-surface.git
patches_src_folder=linux-surface

############################### SETUP ###############################

echo "Updating cache ..."
mkdir -p $cache_folder
cd $cache_folder

# Fetch patches repository
if [ -d $patches_src_folder ]; then
  cd $patches_src_folder && git pull && cd ..
else
  git clone $patches_repository $patches_src_folder
fi

cd ..

############################### INSTALLATION ###############################

# Prompt for modules upload & mkinitcpio rebuild
echo
echo "!!! WARNING !!! The following option will reset the MODULES option in your mkinitcpio config."
echo "!!! WARNING !!! A backup of /etc/mkinitcpio.conf will be saved to /etc/mkinitcpio.conf.bak if you proceed."
read -r -p "1. Update /etc/mkinitcpio.conf using modules from initramfs-tools? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -r -p "Are you installing/using an LTS kernel (<= 4.19)? [y/N] "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        modules=$(echo "MODULES=($(grep -v '^#' base/templates/modules.4.19))" | tr "\n" " " | sed 's/ *$//g')
    else
        modules=$(echo "MODULES=($(grep -v '^#' base/templates/modules))" | tr "\n" " " | sed 's/ *$//g')
    fi
    echo "$modules will be added to /etc/mkinitcpio.conf."
    sudo sed -i.bak -E "s/^MODULES=(.*).*/$modules/" /etc/mkinitcpio.conf
    sudo mkinitcpio
    echo "Done fixing mkinitcpio.conf."
fi

# Prompt for installation of firmware
echo
read -r -p "2. Install all IPTS firmware? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Please install the latest IPTS firmware release from the link below."
  echo "See https://github.com/linux-surface/surface-ipts-firmware/releases"
fi

# Prompt for installation of patched libwacom
echo
read -r -p "3. Would you like to replace libwacom with its patched version? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Please install the package libwacom-surface from the AUR."
  echo "See https://aur.archlinux.org/packages/libwacom-surface/"
fi

############################### CLEANUP ###############################

echo
echo "Setup process finished. Install your patched kernel and then reboot."
