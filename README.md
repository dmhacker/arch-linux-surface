# arch-linux-surface

This is an automated Linux Kernel builder that applies [jakeday's patches](https://github.com/jakeday/linux-surface) to the Linux kernel of your choice. All you have to do is run

```
make
```

and specify what version of Linux you want to patch (i.e. 4.16.7).

As output, you get two packages, the kernel itself as a .pkg.tar.xz file, and its corresponding headers, also as a .pkg.tar.xz file. You can then just run `pacman -U ...` (replace ... with the files) to install both. After that, all you need to do is change your bootloader's configuration to load the updated kernel and `reboot` your system.

I created this because there currently isn't any tool to do something like this. Before this, there were only three options you had:
  * Using the AUR package [linux-surface4](https://aur.archlinux.org/packages/linux-surface4/). This package really shouldn't be used, since it's flagged as out-of-date.
  * Installing one of the pre-built binaries that [pharra provides](https://github.com/pharra/linux-surface). pharra has only releases for the 4.15 series kernel and the patches for these releases have become out-of-date. I can't install them on my system because they were built with gcc 7.3.1, whereas Arch is already on gcc 8.1.
  * Compiling the kernel from source using jakeday's patch repository. However, jakeday doesn't provide instructions on how to build for any system that isn't Debian-based. You would have to refer to the Arch Linux wiki to do so. 
