Installing the REDHAWK IDE for Multiple Users
---------------------------------------------

### Problem

You want to install the REDHAWK IDE so that it can be shared by multiple
users.

### Solution

After
[downloading](http://redhawksdr.github.com/Documentation/download.html)
the REDHAWK IDE for your system. Decide on a location to install the
share IDE installation. Common choices are `/usr/local/redhawk/ide` or
`/opt/redhawk/ide`, in this example we will use `/opt/redhawk/ide`.

    $ sudo mkdir -p /opt/redhawk/ide
    $ sudo mv the-download.zip /opt/redhawk/ide
    $ cd /opt/redhawk/ide
    $ sudo unzip the-redhawk-ide.zip

This will create a `/opt/redhawk/ide/eclipse` folder.

The next step is to pre-cache the Eclipse configuration area

    $ cd eclipse
    $ sudo ./eclipse -clean -initialize

It's recommended (but not required) that you rename this folder so that
you can easily upgrade the IDE when new versions are released.

    $ cd /opt/redhawk/ide
    $ sudo mv eclipse R.X.Y.Z # replace X.Y.Z with the appropriate version number
    $ sudo ln -s R.X.Y.Z default

To make the IDE easy to run from the command line you can make the
following link:

    $ sudo ln -s /opt/redhawk/ide/default/eclipse /usr/local/bin/rhide

Alternately, on REDHAT/CentOS the `alternatives` tool:

    $ sudo alternatives --install \
          /usr/local/bin/rhide rhide /opt/redhawk/ide/R.X.Y.Z/eclipse 0

Or on Ubuntu, use the `update-alternatives` tool

    $ sudo update-alternatives --install \
          /usr/local/bin/rhide rhide /opt/redhawk/ide/R.X.Y.Z/eclipse 0

### Discussion

Providing a common and shared REDHAWK IDE installation is a commonly
done when multiple users share the same machine or the REDHAWK software
is distributed to a set of machines via NFS. If you are the only user of
the machine it's typically sufficient to simply install the REDHAWK IDE
into your home folder.

Because the REDHAWK IDE is built upon [Eclipse](http://www.eclipse.org)
it supports all of the multi-user scenarios that Eclipse supports. The
approach listed above uses the "shared configuration" approach. See the
Eclipse documentation for full details about the details of this
approach, alternate approaches, and processes for updating or extending
a shared install.

### See Also

-   [Eclipse Multi-User
    Installs](http://help.eclipse.org/indigo/index.jsp?topic=%2Forg.eclipse.platform.doc.isv%2Freference%2Fmisc%2Fmulti_user_installs.html)

