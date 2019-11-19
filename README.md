# arch-linux-surface

This is an Arch Linux packager that applies 
[jakeday's patches for Surface devices](https://github.com/jakeday/linux-surface) 
to the Linux kernel of your choice. 

As of November 2019,
the master branch has officially switched over to 
using [qzed's version of these patches](https://github.com/qzed/linux-surface/)
since jakeday's repository appears to be no longer
actively maintained. If you wish to only apply
jakeday's patches, checkout the branch `jakeday`.

## Pre-Installation

First thing you're going to want to do is to clone this repository:

```
git clone https://github.com/dmhacker/arch-linux-surface
cd arch-linux-surface
```

Before you begin compiling & installing the patched kernel, it's recommended that you 
install all necessary firmware that your Surface device needs and replace suspend with hibernate.
You can do this by running the `setup.sh` script with superuser permissions.

```
sudo sh setup.sh
```

Now, you are ready to begin compilation of your kernel.<br>
Alternatively, you could download the 
[pre-built kernel binaries](https://github.com/dmhacker/arch-linux-surface/releases) 
and skip ahead to the installation section.

## Compilation

To generate the build directory for the kernel, you need to run the `configure.sh` script.<br>
The packager will prompt for the target major version of the Linux kernel during configuration.

```
sh configure.sh 
```

Once configure is finished, it will output a directory titled `build-[VERSION]`.<br>
Note that [VERSION] is the full version of the kernel and not just its major version.<br>
To build this kernel, use these two commands: 

```
cd build-[VERSION] 
MAKEFLAGS="-j[NPROC]" makepkg -sc
```

<sup><sub>\* Replace [VERSION] with whatever kernel version configure outputs.<br></sub></sup>
<sup><sub>\*\* Replace [NPROC] with the number of available processors in your machine.</sub></sup>

If you are unable to issue this command because of write permission issues, use the following
command to give yourself access, replacing [USER] and [VERSION] with their appropriate values:

```
chown -R [USER] build-[VERSION]
```

## Installation

When the build process is completed, under `build-[VERSION]`, you will find these packages:
```
linux-surface-[VERSION]-1-x86_64.pkg.tar.xz
linux-surface-headers-[VERSION]-1-x86_64.pkg.tar.xz
linux-surface-docs-[VERSION]-1-x86_64.pkg.tar.xz
```
You can either install them with `sudo pacman -U ...` or do something else with them.

## Troubleshooting

For touchscreen issues, consider looking at [issue #56](https://github.com/dmhacker/arch-linux-surface/issues/56).

For stylus issues, consider looking at [issue #8](https://github.com/dmhacker/arch-linux-surface/issues/8).

For WiFi issues, consider looking at [issue #62](https://github.com/dmhacker/arch-linux-surface/issues/62).

Please do not create new issues regarding these problems if you have not tried to fix them using the above guides.
