# arch-linux-surface

This is an Arch Linux packager that applies 
[jakeday's patches for Surface devices](https://github.com/jakeday/linux-surface) 
to the Linux kernel of your choice. 

## Building

```
git clone https://github.com/dmhacker/arch-linux-surface
cd arch-linux-surface
make
```

The packager will prompt for the target version of the Linux kernel during the build process.
Optionally, you can pass it as a VERSION argument to make. e.g.

```
make VERSION=4.16
```

## Installation

When the build process is completed, under `build-[VERSION]`, you will find these packages:
```
linux-surface-[VERSION]-1-x86_64.pkg.tar.xz
linux-surface-headers-[VERSION]-1-x86_64.pkg.tar.xz
linux-surface-docs-[VERSION]-1-x86_64.pkg.tar.xz
```
You can either install them with `sudo pacman -U ...` or do something else with them.

## Post-Installation

Follow [pharra's instructions](https://github.com/pharra/linux-surface) on how to extract
Surface device firmware from the jakeday's linux-surface repository to your machine. You should
have a cloned copy of this repository already as a result of the build process.  

Once the patched kernel and all firmware is installed, the remaining step is 
to change your bootloader's configuration to load the updated kernel. Then, `reboot` your system.
