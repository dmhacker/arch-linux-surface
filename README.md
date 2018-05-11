# arch-linux-surface

This is an automated Linux Kernel packager that downloads and applies 
[jakeday's patches for Surface devices](https://github.com/jakeday/linux-surface) 
to the Linux kernel of your choice. All you have to do is run

```
MAKEFLAGS="-j$(nproc)" makepkg -si
```
<sup><sub>\* replace $(nproc) with the number of processors on your system</sub></sup>

During the build process, the packager will prompt for the version of the Linux kernel you want. 
At the end of the process, you should have the patched version of that kernel on your system. 
Cool!

Afterwards, all you need to do is change your bootloader's configuration to load the updated 
kernel and `reboot` your system.
