# arch-linux-surface

This is an Arch Linux packager that applies 
[jakeday's patches for Surface devices](https://github.com/jakeday/linux-surface) 
to the Linux kernel of your choice. 

## Building

```
git clone https://github.com/dmhacker/arch-linux-surface
cd arch-linux-surface
./configure.sh
```

The packager will prompt for the target version of the Linux kernel during configuration.
Optionally, you can pass the version as an argument to configure. e.g.

```
./configure.sh 4.16
```

Once configure is finished, it will output a directory titled `build-[VERSION]`. To build
that specific patched kernel, you can run: 

```
cd build-[VERSION] && MAKEFLAGS="-j[NPROC]" makepkg -sc
```

Be sure to replace [VERSION] with whatever kernel version you choose. [NPROC] should be replaced
by the number of available processors in your machine. 

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
