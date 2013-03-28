Configuring Ubuntu for REDHAWK Development
------------------------------------------

### Problem

You want to develop REDHAWK components or devices on your Ubuntu system.

### Solution

To build REDHAWK components or devices (especially those using the C++
programming language) you will need various development tools and
packages.

    $ sudo apt-get install redhawk-build-essential

Next, ensure that you have configured REDHAWK for development:

    $ dpkg-reconfigure redhawk

When prompted to "Allow development access to SDRROOT?" answer **Yes**.
This will ensure that users in the `redhawk` group will be able to write
files to the necessary folders in `/var/redhawk/sdr` (i.e. `$SDRROOT`).

Then add yourself to the `redhawk` group:

    $ sudo adduser ${USER} redhawk

If you intend to use the REDHAWK IDE for development, then it is
recommended that you install the Ubuntu relevant patches provided by the
[Axios REDHAWK IDE
Update-Site](https://github.com/Axios-Engineering/redhawk-ide-patch-updatesite).

### Discussion

By default, Ubuntu systems come stripped-down and don't include
compilers and header files for libraries. The `build-essential` package
includes most of the basics that you need while the `*-dev` packages
install the development headers (among other things).

The default installation of REDHAWK provides a shared area,
`/var/redhawk/sdr`, where components, devices, waveforms, and nodes are
installed. For security reasons, only users that are in the `redhawk`
group are allowed to write to the necessary folders. You can verify the
settings using `ls -l`:

    $ ls -l $SDRROOT/dom
    total 16
    drwxrwsr-x 4 root redhawk 4096 Mar 18 20:51 components
    drwxr-xr-x 2 root root    4096 Mar 18 20:00 domain
    drwxr-xr-x 2 root root    4096 Mar 18 20:00 mgr
    drwxrwsr-x 2 root redhawk 4096 Mar 17 23:41 waveforms

    $ ls -l $SDRROOT/dev
    total 12
    drwxrwsr-x 3 root redhawk 4096 Mar 17 19:16 devices
    drwxr-xr-x 2 root root    4096 Mar 18 20:00 mgr
    drwxrwsr-x 3 root redhawk 4096 Mar 18 20:00 nodes

The "sticky-bit" (i.e. the `s` flag) ensures that directories and
folders created in the components, devices, waveforms, and nodes folders
inherit the `redhawk` group.
