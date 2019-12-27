#!/usr/bin/bash

echo "This script was created to simplify the setup process for Surface devices running Arch Linux."
echo

cache_folder=.cache_setup
patches_repository=git://github.com/qzed/linux-surface.git
patches_src_folder=linux-surface
firmware_src_folder="$cache_folder/$patches_src_folder/firmware"

############################### SETUP ###############################

# This cache is purely temporary (fixes issues with superuser permissions)
echo "Creating temporary cache ..."
mkdir -p $cache_folder
cd $cache_folder

# Only the patches repository needs to be tracked
if [ -d $patches_src_folder ]; then
  cd $patches_src_folder && git pull && cd ..
else
  git clone $patches_repository $patches_src_folder
fi

# Exit the cache folder
cd ..

############################### INSTALLATION ###############################

# Prompt for installation of root files
echo
read -r -p "1. Copy config files from qzed's kernel to root? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Unpacking files to / ..."
  cp -r $cache_folder/$patches_src_folder/root/etc/* /etc
  mkdir -p /lib/systemd/system-sleep
  cp $cache_folder/$patches_src_folder/root/lib/systemd/system-sleep/sleep /lib/systemd/system-sleep

  echo "Making /lib/systemd/system-sleep/sleep executable ..."
  chmod a+x /lib/systemd/system-sleep/sleep

  echo "Done copying config files."
fi

# Prompt for modules upload & mkinitcpio rebuild
echo
echo "!!! WARNING !!! The following option will reset the MODULES option in your mkinitcpio config."
echo "!!! WARNING !!! A backup of /etc/mkinitcpio.conf will be saved to /etc/mkinitcpio.conf.old if you proceed."
read -r -p "2. Rebuild kernel with modules from /etc/initramfs-tools/modules? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup
    modules=$(echo "MODULES=($(grep -v '^#' $cache_folder/$patches_src_folder/root/etc/initramfs-tools/modules))" | tr "\n" " " | sed 's/ *$//g')
    sed -i "/^MODULES=(.*)/c\\$modules" /etc/mkinitcpio.conf
    echo "$modules will be added to /etc/mkinitcpio.conf."
    mkinitcpio
fi

# Prompt for replacement of suspend with hibernate
echo
read -r -p "3. Replace suspend with hibernate? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Symlinking suspend target/service to hibernate target/service ..."
  ln -sf /lib/systemd/system/hibernate.target /etc/systemd/system/suspend.target
  ln -sf /lib/systemd/system/systemd-hibernate.service /etc/systemd/system/systemd-suspend.service
  echo "Done replacing suspend with hibernate."
fi

# Prompt for installation of firmware
echo
read -r -p "4. Install all firmware to /lib/firmware? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Copying files to /lib/firmware ..."
  mkdir -p /lib/firmware
  cp -rv $firmware_src_folder/* /lib/firmware
  echo "Done installing firmware."
fi

############################### CLEANUP ###############################

# Remove the cache folder to handle permission issues
echo ""
echo "Removing temporary cache ..."
rm -rf $cache_folder

# Yay! All done.
echo
echo "Setup process finished!"
echo "Install your patched kernel and then reboot."
