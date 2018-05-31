#!/usr/bin/bash

echo "This script was created to simplify the setup process for Surface devices running Arch Linux."
echo 

cache_folder=.cache
patches_repository=git://github.com/jakeday/linux-surface.git
patches_src_folder=linux-surface
firmware_src_folder="$cache_folder/$patches_src_folder/firmware"

############################### CACHE UPDATES ############################### 

# The cache is used for holding the large linux-stable and linux-surface repositories
# In this script, we only care about the linux-surface repository
echo "Updating cache ..."
mkdir -p $cache_folder
cd $cache_folder

# Do the same with the patches repository
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
read -r -p "Copy config files from jakeday's kernel to root? [Y/n] "
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Unpacking files to / ..."
  cp -r $cache_folder/$patches_src_folder/root/etc/* /etc
  mkdir -p /lib/systemd/system-sleep
  cp $cache_folder/$patches_src_folder/root/lib/systemd/system-sleep/hibernate /lib/systemd/system-sleep

  echo "Making /lib/systemd/system-sleep/hibernate executable ..."
  chmod a+x /lib/systemd/system-sleep/hibernate
  
  echo "Done copying config files."
fi

# Prompt for installation of Marvel firmware
echo
read -r -p "Install Marvel firmware for WiFi? [Y/n] "

# User selected 'yes' option 
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Unpacking files to /lib/firmware/mrvl ..."
  mkdir -p /lib/firmware/mrvl/
  unzip -o $firmware_src_folder/mrvl_firmware.zip -d /lib/firmware/mrvl
  echo "Done installing Marvel firmware."
fi

# Prompt for installation for IPTS firmware
echo
read -r -p "Install IPTS firmware to enable the touchscreen? [Y/n] "

# User selected 'yes' option 
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "What Surface model is your device? Enter the number corresponding to your selection."
  select SURFACE_MODEL in "Surface Pro 3" "Surface Pro 4" "Surface Pro 2017" "Surface Laptop" "Surface Book" "Surface Book 2 13\"" "Surface Book 2 15\""; do
    break;
  done

  echo "Now installing IPTS firmware for the $SURFACE_MODEL ..."

  i915_folder=/lib/firmware/i915/
  intel_ipts_folder=/lib/firmware/intel/ipts/
  nvidia_folder=/lib/firmware/nvidia/gp108/

  case $SURFACE_MODEL in
    "Surface Pro 3")
      echo "Unpacking files to $i915_folder ..."
      mkdir -p $i915_folder 
      unzip -o $firmware_src_folder/i915_firmware_bxt.zip -d $i915_folder 
      ;;
    "Surface Pro 4")
      echo "Unpacking files to $intel_ipts_folder ..."
      mkdir -p $intel_ipts_folder 
      unzip -o $firmware_src_folder/ipts_firmware_v78.zip -d $intel_ipts_folder 

      echo "Unpacking files to $i915_folder ..."
      mkdir -p $i915_folder 
      unzip -o $firmware_src_folder/i915_firmware_skl.zip -d $i915_folder 
      ;;
    "Surface Pro 2017")
      echo "Unpacking files to $intel_ipts_folder ..."
      mkdir -p $intel_ipts_folder 
      unzip -o $firmware_src_folder/ipts_firmware_v102.zip -d $intel_ipts_folder 

      echo "Unpacking files to $i915_folder ..."
      mkdir -p $i915_folder 
      unzip -o $firmware_src_folder/i915_firmware_kbl.zip -d $i915_folder 
      ;;
    "Surface Laptop")
      echo "Unpacking files to $intel_ipts_folder ..."
      mkdir -p $intel_ipts_folder 
      unzip -o $firmware_src_folder/ipts_firmware_v79.zip -d $intel_ipts_folder 

      echo "Unpacking files to $i915_folder ..."
      mkdir -p $i915_folder 
      unzip -o $firmware_src_folder/i915_firmware_skl.zip -d $i915_folder 
      ;;
    "Surface Book")
      echo "Unpacking files to $intel_ipts_folder ..."
      mkdir -p $intel_ipts_folder 
      unzip -o $firmware_src_folder/ipts_firmware_v76.zip -d $intel_ipts_folder 

      echo "Unpacking files to $i915_folder ..."
      mkdir -p $i915_folder 
      unzip -o $firmware_src_folder/i915_firmware_skl.zip -d $i915_folder 
      ;;
    "Surface Book 2 13\"")
      echo "Unpacking files to $intel_ipts_folder ..."
      mkdir -p $intel_ipts_folder 
      unzip -o $firmware_src_folder/ipts_firmware_v137.zip -d $intel_ipts_folder 

      echo "Unpacking files to $i915_folder ..."
      mkdir -p $i915_folder 
      unzip -o $firmware_src_folder/i915_firmware_kbl.zip -d $i915_folder 

      echo "Unpacking files to $nvidia_folder ..."
      mkdir -p $nvidia_folder
      unzip -o $firmware_src_folder/nvidia_firmware_gp108.zip -d $nvidia_folder
      ;;
    "Surface Book 2 15\"")
      echo "Unpacking files to $intel_ipts_folder ..."
      mkdir -p $intel_ipts_folder 
      unzip -o $firmware_src_folder/ipts_firmware_v101.zip -d $intel_ipts_folder 

      echo "Unpacking files to $i915_folder ..."
      mkdir -p $i915_folder 
      unzip -o $firmware_src_folder/i915_firmware_kbl.zip -d $i915_folder 

      echo "Unpacking files to $nvidia_folder ..."
      mkdir -p $nvidia_folder
      unzip -o $firmware_src_folder/nvidia_firmware_gp108.zip -d $nvidia_folder
      ;;
    *)
      echo "Invalid selection. Moving on."
      ;;
  esac
fi

# Yay! All done.
echo 
echo "Setup process finished!"
echo "Install your patched kernel and then reboot."
