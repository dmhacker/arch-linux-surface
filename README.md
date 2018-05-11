# arch-linux-surface

This is an Arch Linux packager that applies 
[jakeday's patches for Surface devices](https://github.com/jakeday/linux-surface) 
to the Linux kernel of your choice. 

All you have to do is run
```
git clone https://github.com/dmhacker/arch-linux-surface
cd arch-linux-surface
MAKEFLAGS="-j$(nproc)" makepkg -si
```
<sup><sub>\* replace $(nproc) with the number of processors on your system</sub></sup>

During the build process, the packager will prompt for the version of the Linux kernel you want. 
After compilation finishes, you should have the patched version of that kernel installed on 
your system. 

If you ran `makepkg` without the `-i` flag, the kernel will appear as three separate files:
```
linux-surface-{VERSION}-1.pkg.tar.xz
linux-surface-headers-{VERSION}-1.pkg.tar.xz
linux-surface-docs-{VERSION}-1.pkg.tar.xz
```
You can either install them with `pacman -U ...` or do something else with them.

Once the patched kernel is installed, the final step is to change your bootloader's 
configuration to load the updated kernel. Then, `reboot` your system.
