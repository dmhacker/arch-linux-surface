#!/usr/bin/bash

############################### VERSION SELECTION ############################### 

# User did not enter a major version selection, prompt for one
if [ "$1" = "" ]; then
  echo "Which kernel version do you want to build?"
  select major_version in "4.19" "5.3" "5.4" "5.5"; do
    break;
  done
else
  major_version=$1
fi

# Convert major version (e.g. 4.14) to full version (e.g. 4.14.40)
case $major_version in
  "4.19")
    version="4.19.91"
    release_number=1
    ;;
  "5.3")
    version="5.3.18"
    release_number=1
    ;;
  "5.4")
    version="5.4.6"
    release_number=1
    ;;
  "5.5")
    version="5.5.3"
    release_number=1
    ;;
  *)
    echo "Invalid selection!"
    exit 1
    ;;
esac

############################### VARIABLES ############################### 

cache_folder=.cache
build_folder=build-${version}-${release_number}
kernel_repository=git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git 
kernel_src_folder=linux-stable
patches_repository=git://github.com/qzed/linux-surface.git
patches_src_folder=linux-surface

kernel_suffix="-surface"
if [ "$major_version" = "4.19" ]; then
  kernel_suffix="-surface-lts"
fi

############################### CACHE UPDATES ############################### 

# Cache is used for holding frequently used repositories
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

############################### BUILD UPDATES ############################### 

# Copy templates
echo "Installing fresh set of template files ..." 
rm -rf $build_folder 
mkdir $build_folder 
cp base/templates/* $build_folder 

# Enter the newly created build directory
cd $build_folder

# Add kernel repository 
echo "Creating symlink to kernel source code ..."
ln -s ../$cache_folder/$kernel_src_folder $kernel_src_folder

# Add Surface device patches
echo "Creating symlinks to Surface device patches ..."
for src in ../$cache_folder/$patches_src_folder/patches/$major_version/*.patch; do
    filename=$(basename $src)
    patch_entry="  ${filename}"
    skip_entry="            'SKIP'"
    ln -s "$src" "$filename"
    if [[ -z "$surface_patches" ]]; then
        surface_patches="$patch_entry"
        patch_skips="$skip_entry"
    else
        surface_patches="${surface_patches}\n${patch_entry}"
        patch_skips="${patch_skips}\n${skip_entry}"
    fi
done

# Fill in blank variables in PKGBUILD
echo "Adjusting PKGBUILD version ..."
pkgbuild=`cat PKGBUILD`
pkgbuild="${pkgbuild/\{0\}/$kernel_suffix}"
pkgbuild="${pkgbuild/\{1\}/$major_version}"
pkgbuild="${pkgbuild/\{2\}/$version}"
pkgbuild="${pkgbuild/\{3\}/$release_number}"
pkgbuild="${pkgbuild/\{4\}/$surface_patches}"
pkgbuild="${pkgbuild/\{5\}/$patch_skips}"
echo -e "$pkgbuild" > PKGBUILD

# Add version-specific configuration file
echo "Copying v$major_version .config file ..."
versioned_config="config.$major_version"
cp ../base/configs/$versioned_config .
mv $versioned_config config

# Exit the build directory
cd ..

############################### NEXT INSTRUCTIONS ############################### 

nproc=`grep -c ^processor /proc/cpuinfo`
echo ""
echo "Build files for patched Linux kernel v$version are in $build_folder."
echo "The following commands can be used to build the kernel packages."
echo ""
echo "cd $build_folder"
echo "MAKEFLAGS=\"-j$nproc\" makepkg -sc"
echo ""
echo "You can optionally provide the -i flag to makepkg to install the kernel after build."
