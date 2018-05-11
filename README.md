# arch-linux-surface

This is an Arch Linux packager that applies 
[jakeday's patches for Surface devices](https://github.com/jakeday/linux-surface) 
to the Linux kernel of your choice. 

## Building 

```
git clone https://github.com/dmhacker/arch-linux-surface
cd arch-linux-surface
MAKEFLAGS="-j$(nproc)" makepkg -s
```
<sup><sub>\* replace **$(nproc)** with the number of processors on your system</sub></sup><br>
<sup><sub>\*\* use **makepkg -si** to install the new kernel immediately after build</sub></sup>

The packager will prompt for the target version of the Linux kernel during the build process.

## Installation

If you ran `makepkg` without the `-i` flag, the kernel will appear as three separate files:
```
linux-surface-{VERSION}-1-x86_64.pkg.tar.xz
linux-surface-headers-{VERSION}-1-x86_64.pkg.tar.xz
linux-surface-docs-{VERSION}-1-x86_64.pkg.tar.xz
```
You can either install them with `pacman -U ...` or do something else with them.

## Post-Installation

Once the patched kernel is installed, the remaining step is to change your bootloader's 
configuration to load the updated kernel. Then, `reboot` your system.
