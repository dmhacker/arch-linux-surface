# arch-linux-surface

This is an automated Linux Kernel packager that applies 
[jakeday's patches](https://github.com/jakeday/linux-surface) 
to the Linux kernel of your choice. All you have to do is run

```
makepkg -si
```

and specify what version of Linux you want to patch (i.e. 4.16). At the end of the process, you
should have a working, patched kernel on your system. Cool!

Optionally, you could leave out the `-i` flag. This tells the package builder to build the kernel
without installing it. As output, you get the kernel itself and its headers as two separate 
.pkg.tar.xz files. If you want to install these packages, run `pacman -U ...` on the target file.
It's recommended that you install the headers file first though, so that you can compile any
modules that depend on them.

Afterwards, all you need to do is change your bootloader's configuration to load the updated 
kernel and `reboot` your system.

The other option is to use 
I created this because there currently isn't any tool to do something like this. Before this, there were only three options you had:
  * Using the AUR package [linux-surface4](https://aur.archlinux.org/packages/linux-surface4/). This package really shouldn't be used, since it's flagged as out-of-date.
  * Installing one of the pre-built binaries that [pharra provides](https://github.com/pharra/linux-surface). pharra has only releases for the 4.15 series kernel and the patches for these releases have become out-of-date. I can't install them on my system because they were built with gcc 7.3.1, whereas Arch is already on gcc 8.1.
  * Compiling the kernel from source using jakeday's patch repository. However, jakeday doesn't provide instructions on how to build for any system that isn't Debian-based. You would have to refer to the Arch Linux wiki to do so. 
