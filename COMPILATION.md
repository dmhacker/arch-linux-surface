# User Compilation

---

Most users should simply use the pre-built binary releases rather than try to compile
the kernel on their own, since it takes significant resources, setup, and time. However,
if you are interested in compiling your own kernel, then the steps below will walk you
through how to do so.

---

To generate the build directory for the kernel, you need to run the `configure.sh` script.<br>
The packager will prompt for the target major version of the Linux kernel during configuration.

```
sh configure.sh 
```

Once configure is finished, it will output a directory titled `build-{VERSION}`.<br>
Note that {VERSION} is the full version of the kernel and not just its major version.<br>
To build this kernel, use these two commands: 

```
cd build-{VERSION}
MAKEFLAGS="-j{NPROC}" makepkg -sc
```

<sup><sub>\* Replace {VERSION} with whatever kernel version configure outputs.<br></sub></sup>
<sup><sub>\*\* Replace {NPROC} with the number of available processors in your machine.</sub></sup>

If you are unable to issue this command because of write permission issues, use the following
command to give yourself access, replacing {USER} and {VERSION} with their appropriate values:

```
chown -R {USER} build-{VERSION}
```
