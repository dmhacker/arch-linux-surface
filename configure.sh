#!/usr/bin/bash

if [ "$1" = "" ]; then
  echo "Which kernel version do you want to build?"
  select major_version in "4.14" "4.15" "4.16"; do
    break;
  done
else
  major_version=$1
fi

case $major_version in
  "4.14")
    version="4.14.40"
    ;;
  "4.15")
    version="4.15.18"
    ;;
  "4.16")
    version="4.16.8"
    ;;
  *)
    echo "Invalid selection!"
    echo "Valid options are 4.14, 4.15, 4.16."
    exit 1
    ;;
esac

cache_folder=.cache
build_folder=build-${version}
kernel_repository=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
kernel_src_folder=linux-stable
patches_repository=git://github.com/jakeday/linux-surface.git
patches_src_folder=linux-surface

# The cache is used for holding the large linux-stable and linux-surface repositories
echo "Updating cache ..."
mkdir -p $cache_folder
cd $cache_folder

# Update kernel source if repository is there, otherwise clone
if [ -d $kernel_src_folder ]; then
  cd $kernel_src_folder && git pull && cd ..
else
  git clone $kernel_repository $kernel_src_folder
fi

# Do the same with the patches repository
if [ -d $patches_src_folder ]; then
  cd $patches_src_folder && git pull && cd ..
else
  git clone $patches_repository $patches_src_folder
fi

# Exit the cache folder 
cd ..

# Copy templates
echo "Copying template files to build directory ..." 
rm -rf $build_folder 
mkdir $build_folder 
cp templates/* $build_folder 

echo "Configuring build ..." 
cd $build_folder

# Fill in blank variables in PKGBUILD
pkgbuild=`cat PKGBUILD` 
pkgbuild="${pkgbuild/\{0\}/$major_version}"
pkgbuild="${pkgbuild/\{1\}/$version}"
echo "$pkgbuild" > PKGBUILD

# Copy items from the cache into the build directory
cp -R ../$cache_folder/$kernel_src_folder . 

# Add patches to the build directory
mkdir patches
if [ -d "../patches/$major_version" ]; then
  cp ../patches/$major_version/*.patch patches
fi
cp ../$cache_folder/$patches_src_folder/patches/$major_version/*.patch patches

# Copy modified configuration file
cp ../config/config.$major_version .
mv config.$major_version .config

# Update package checksums to account for new configuration file
updpkgsums

nproc=`grep -c ^processor /proc/cpuinfo`
echo ""
echo "Build files for patched Linux kernel v$version are in $build_folder."
echo "The following command can be used to build the kernel packages."
echo ""
echo "cd $build_folder && MAKEFLAGS=\"-j$nproc\" makepkg -sc"
echo ""
echo "You can optionally provide the -i flag to makepkg install the kernel after build."
