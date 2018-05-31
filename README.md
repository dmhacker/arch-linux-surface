# arch-linux-surface

This is an Arch Linux packager that applies 
[jakeday's patches for Surface devices](https://github.com/jakeday/linux-surface) 
to the Linux kernel of your choice. 

## Building

First thing you're going to want to do is to clone this repository:

```
git clone https://github.com/dmhacker/arch-linux-surface
cd arch-linux-surface
```

Before you begin compiling & installing the patched kernel, it's recommended that you 
install all necessary firmware that your Surface device needs and replace suspend with hibernate.
You can do this by running the `setup.sh` script with superuser permissions.

```
sudo sh /setup.sh
```

To generate the build directory for the kernel, you need to run the `configure.sh` script.<br>
The packager will prompt for the target major version of the Linux kernel during configuration.

```
sh configure.sh 
```

Once configure is finished, it will output a directory titled `build-[VERSION]`.<br>
Note that [VERSION] is the full version of the kernel and not just its major version.<br>
To build this kernel, use the command: 

```
cd build-[VERSION] && MAKEFLAGS="-j[NPROC]" makepkg -sc
```

<sup><sub>\* Replace [VERSION] with whatever kernel version configure outputs.<br></sub></sup>
<sup><sub>\*\* Replace [NPROC] with the number of available processors in your machine.</sub></sup>

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
Surface device firmware from the jakeday's linux-surface repository to your machine. 

Once the patched kernel and all firmware is installed, the remaining step is 
to change your bootloader's configuration to load the updated kernel. Then, `reboot` your system.
