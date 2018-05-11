# arch-linux-surface

This is an automated Linux Kernel packager that applies 
[jakeday's patches](https://github.com/jakeday/linux-surface) 
to the Linux kernel of your choice. All you have to do is run

```
MAKEFLAGS="-j$(nproc)" makepkg -si
```
<sup><sub>* replace $(nproc)$ with the number of processors on your system<\sub><\sup>

During the build process, the packager will ask what version of the Linux kernel to patch. At the end of the process, you should have the patched version of that kernel on your system. Cool!

Afterwards, all you need to do is change your bootloader's configuration to load the updated 
kernel and `reboot` your system.

I created this because there currently isn't any tool to do something like this. 
Before this, there were only three options you had:
  * Using the AUR package [linux-surface4](https://aur.archlinux.org/packages/linux-surface4/). 
    This package really shouldn't be used, since it's flagged as out-of-date.
  * Installing one of the pre-built binaries that [pharra provides](https://github.com/pharra/linux-surface). 
    pharra has only releases for the 4.15 series kernel and they have already become out-of-date. 
    I can't install them on my system because they were built with gcc 7.3.1, whereas Arch 
    is already on gcc 8.1.
  * Compiling the kernel from source using jakeday's patch repository. 
    However, jakeday doesn't provide instructions on how to build for any system 
    that isn't Debian-based. This is an attempt to automate that process. 
