Installing The REDHAWK Core Framework on Ubuntu
-----------------------------------------------

### Problem

You want to install REDHAWK on Ubuntu.

### Solution

Currently redhawksdr.org only provides pre-built binaries for the
CentOS5 and CentOS6 operating-systems. Luckily, REDHAWK has been ported
to Ubuntu 12.04 (Precise) and Ubuntu 12.10 (Quantal) and is easily
installable from an Ubuntu Personal-Package-Archive (PPA). The first
step is to add the [Axios REDHAWK
PPA](https://launchpad.net/~axios/+archive/redhawk) to your system:

    $ sudo add-apt-repository ppa:axios/redhawk
    You are about to add the following PPA to your system:
     Axios provided Ubuntu packages for the REDHAWK Software Defined Radio framework.

    http://www.redhawksdr.org
    http://www.axiosengineering.com
     More info: https://launchpad.net/~axios/+archive/redhawk
    Press [ENTER] to continue or ctrl-c to cancel adding it

After pressing **Enter**, you will update the package information on
your system:

    $ sudo apt-get update

Once the package information is updated, installation is
straight-forward:

    $ sudo apt-get install redhawk \
                           redhawk-sdrroot-dom-mgr \
                           redhawk-sdrroot-dev-mgr \
                           redhawk-sdrroot-dom-profile \
                           redhawk-bulkiointerfaces \
                           redhawk-device-gpp

You may be prompted to "Allow development access to SDRROOT?", if you
intend to use your system for development answer **Yes**.

Once the installation has completed, there is a small amount of system
configuration that is required. This can be done with any text-editor of
your choice, or by using the below commands:

    $ echo ". /etc/profile.d/redhawk.sh" >> ~/.bashrc
    $ echo ". /etc/profile.d/redhawk-sdrroot.sh" >> ~/.bashrc

Finally, it is recommended that you edit your `/etc/omniORB.cfg` file:

    $ sudo gedit /etc/omniORB.cfg

and make the following changes:

~~~~ {.diff}
@@ @@
#
#    Valid values = (n >= 8192)
#
-giopMaxMsgSize = 2097152    # 2 MBytes.
+giopMaxMsgSize = 10485760   # 10 MBytes.

############################################################################
# strictIIOP flag
#    Enable vigorous check on incoming IIOP messages
#
@@ @@
#
#DefaultInitRef = corbaloc::
InitRef = NameService=corbaname::localhost
InitRef = EventService=corbaloc::localhost:11169/omniEvents

############################################################################
# clientTransportRule
#
@@ @@
#   endPointNoPublish = giop:tcp::
#                     = giop:unix:
#                     = giop:ssl::
#
+endPoint = giop:unix:
+endPoint = giop:tcp::

############################################################################
# endPointPublish
#
~~~~

Now you can start the REDHAWK *DomainManager*

    $ nodeBooter -D

### Discussion

In addition to being packaged as Debian package, the REDHAWK Ubuntu
packages distributed by Axios include patches that are necessary for
proper operation of REDHAWK. As new versions of REDHAWK or Ubuntu are
released these packages will be updated. You can pull in these updates
using the regular Ubuntu upgrade process:

    $ sudo apt-get update
    $ sudo apt-get upgrade

When developing components and devices on Ubuntu you may run into
problems where scripts such as `build.sh` fail to run correctly. This is
because, by default, Ubuntu uses the `dash` shell as it's `/bin/sh`
interpreter.

The simple solution is to reconfigure your Ubuntu system to use `bash`
instead:

    $ sudo dpkg-reconfigure dash

When prompted to " Use dash as the default system shell" answer *No*.
The downside of this approach is that your system boot-up time may be
*slightly* slower (although it's unlikely that you will notice).
Alternatively, you can change the first-line in the scripts to be
`#!/bin/bash`.

REDHAWK is based upon the Software Communications Architecture (SCA)
version 2.2.2 specification and therefore it relies on CORBA for
interprocess communication. REDHAWK uses the omniORB package as it's
CORBA implementation; the customization of `omniORB.cfg` serves two
purposes:

-   There is a small bug with the way the REDHAWK version 1.8.3 resolves
    the `EventService`. By removing the `DefaultInitRef` and adding the
    specific `InitRef` this problem is avoided
-   Adding the `endPoint` lines allows omniORB to take advantage of the
    higher-performance unix-domain-sockets for CORBA transfers.

Finally, the lines in the `~/.bashrc` that source `redhawk.sh` and
`redhawk-sdrroot.sh` setup a various environment variables that REDHAWK
requires for proper operation:

-   `$OSSIEHOME` is the location of the REDHAWK core framework
    installation (in this case `/usr/redhawk`)
-   `$SDRROOT` is the location that components, devices, nodes, and
    waveforms are installed.
-   `$PATH`, `$PYTHONPATH`, `$LD_LIBRARY_PATH`, `$CLASSPATH`, and
    `$JAVA_HOME` setup various system paths to allow REDHAWK to properly
    run.

Unlike other Linux-based operating systems, Ubuntu does not run the
contents of `/etc/profile.d` when you open a terminal. As an alternative
to the directions above, you can configure `gnome-terminal` to create a
login shell.

1.  Start a gnome-terminal.
2.  Go to Edit -\> Profile Preferences -\> Title and Command
3.  Enable "Run Command as a login shell".
4.  Restart the gnome-terminal.

