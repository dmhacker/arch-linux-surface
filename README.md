# arch-linux-surface

This is an Arch Linux packager that applies 
[patches for Surface devices](https://github.com/linux-surface/linux-surface) 
to the Linux kernel of your choice. 

This repository originally tracked jakeday's repository on the `master` branch.
As of November 2019, the `master` branch has officially switched over to 
using linux-surface's version of these patches since jakeday's repository 
appears to be no longer actively maintained. As of March 2020, support
for jakeday's patches has been dropped.

Additionally, please refer to [the linux-surface repository itself](https://github.com/linux-surface/linux-surface/wiki/Package-Repositories#arch-linux-repository)
as another source of builds compatible with Arch Linux.
This repository will continue to be actively maintained by
me though, so you are welcome to use either source.

## Pre-Installation

First thing you're going to want to do is to clone this repository:

```
git clone https://github.com/dmhacker/arch-linux-surface
cd arch-linux-surface
```

Before you begin compiling & installing the patched kernel, it's recommended that you 
install all necessary firmware that your Surface device needs and replace suspend with hibernate.
You can do this by running the `setup.sh` script WITHOUT superuser permissions.

```
sh setup.sh
```

As of December 2019, the setup script should NOT be run with superuser permissions. This is both
by design and for your own safety. If the script requires superuser permissions at any point in
time, it will prompt you for them.

## Installation

After you have run the setup script, it is now time to install the patched kernel.
Find the latest version {VERSION}* in the [pre-built binary releases](https://github.com/dmhacker/arch-linux-surface/releases) 
and download the following tar files:

* linux-surface-{VERSION}-x86_64.pkg.tar.xz
* linux-surface-headers-{VERSION}-x86_64.pkg.tar.xz

<sup>*Replace {VERSION} with whatever the latest version number is. For example, 5.13.15-1.</sup>

After you have downloaded these files, `cd` into the directory containing them
and run the following commands:

```
sudo pacman -U linux-surface-headers-{VERSION}-x86_64.pkg.tar.xz
sudo pacman -U linux-surface-{VERSION}-x86_64.pkg.tar.xz
```

You are now finished. Reboot your system and change your bootloader to 
load the `linux-surface` kernel.

## Additional Packages

Consider installing the following packages from the AUR if your device
meets the given requirements.

* [libwacom-surface](https://aur.archlinux.org/packages/libwacom-surface) — all devices — may help fix IPTS/touchscreen issues
* [surface-control](https://aur.archlinux.org/packages/surface-control/) — Surface Book 2 only — provides an interface for controlling the SB2's dGPU
* [surface-dtx-daemon](https://aur.archlinux.org/packages/surface-dtx-daemon/) — Surface Book 2 only — improves the clipboard detachment process for the SB2

## Troubleshooting

For touchscreen issues, consider looking at [issue #56](https://github.com/dmhacker/arch-linux-surface/issues/56).

For stylus issues, consider looking at [issue #8](https://github.com/dmhacker/arch-linux-surface/issues/8).

For WiFi issues, consider looking at [issue #62](https://github.com/dmhacker/arch-linux-surface/issues/62).

Please do not create new issues regarding these problems if you have not tried to fix them using the above guides.
