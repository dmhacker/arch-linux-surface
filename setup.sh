#!/usr/bin/bash

if [ "$EUID" -eq 0 ]
  then echo "Do not run this script as root."
  exit
fi

echo "This script will prepare Surface devices for installation of a patched Arch Linux kernel."
echo "Answer 'y' to any options you wish to install. By default, options are unselected."
echo

cache_folder=.cache
patches_repository=git://github.com/qzed/linux-surface.git
patches_src_folder=linux-surface
firmware_src_folder="$cache_folder/$patches_src_folder/firmware"
libwacom_repository=git://github.com/qzed/libwacom-surface.git
libwacom_src_folder=libwacom-surface

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

# Fetch libwacom repository
if [ -d $libwacom_src_folder ]; then
  cd $libwacom_src_folder && git pull && cd ..
else
  git clone $libwacom_repository $libwacom_src_folder
fi

cd ..

############################### INSTALLATION ###############################

# Prompt for installation of root files
echo
read -r -p "1. Copy config files from qzed's kernel to root? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Unpacking files to / ..."
  sudo cp -r $cache_folder/$patches_src_folder/root/etc/* /etc
  sudo mkdir -p /lib/systemd/system-sleep
  sudo cp $cache_folder/$patches_src_folder/root/lib/systemd/system-sleep/sleep /lib/systemd/system-sleep
  echo "Making /lib/systemd/system-sleep/sleep executable ..."
  sudo chmod a+x /lib/systemd/system-sleep/sleep
  echo "Done copying config files."
fi

# Prompt for modules upload & mkinitcpio rebuild
echo
echo "!!! WARNING !!! The following option will reset the MODULES option in your mkinitcpio config."
echo "!!! WARNING !!! A backup of /etc/mkinitcpio.conf will be saved to /etc/mkinitcpio.conf.bak if you proceed."
read -r -p "2. Update /etc/mkinitcpio.conf using modules from initramfs-tools? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
    modules=$(echo "MODULES=($(grep -v '^#' $cache_folder/$patches_src_folder/root/etc/initramfs-tools/modules))" | tr "\n" " " | sed 's/ *$//g')
    echo "$modules will be added to /etc/mkinitcpio.conf."
    sudo sed -i.bak -E "s/^MODULES=(.*).*/$modules/" /etc/mkinitcpio.conf
    sudo mkinitcpio
    echo "Done fixing mkinitcpio.conf."
fi

# Prompt for replacement of suspend with hibernate
echo
read -r -p "3. Replace suspend with hibernate? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Symlinking suspend target/service to hibernate target/service ..."
  sudo ln -sf /lib/systemd/system/hibernate.target /etc/systemd/system/suspend.target
  sudo ln -sf /lib/systemd/system/systemd-hibernate.service /etc/systemd/system/systemd-suspend.service
  echo "Done replacing suspend with hibernate."
fi

# Prompt for installation of firmware
echo
read -r -p "4. Install all firmware to /lib/firmware? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Copying files to /lib/firmware ..."
  sudo mkdir -p /lib/firmware
  sudo cp -rv $firmware_src_folder/* /lib/firmware
  echo "Done installing firmware."
fi

# Prompt for installation of patched libwacom
echo
read -r -p "5. Would you like to replace libwacom with its patched version? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Please install the package libwacom-surface from the AUR."
  echo "See https://aur.archlinux.org/packages/libwacom-surface/"
fi

############################### CLEANUP ###############################

echo
echo "Setup process finished. Install your patched kernel and then reboot."
