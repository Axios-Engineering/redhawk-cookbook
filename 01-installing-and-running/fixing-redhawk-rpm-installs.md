Fixing REDHAWK RPM Installation Problems
----------------------------------------

### Problem

You cannot install REDHAWK on your CentOS/Fedora operating system due to
some form of error.

A common error is due to incompatibilities between the REDHAWK RPMs and
those available from the Extra Packages for Enterprise Linux (EPEL)
repository. You will see messages such as:

    Error: Package: omniORB-servers-4.1.6-2.el6.x86_64 (epel)
           Requires: omniORB = 4.1.6-2.el6
           Installing: libomniORB4.1-4.1.0-0.3.x86_64 (REDHAWK-DEPS)
               omniORB = 4.1.0-0.3
           Available: omniORB-4.1.6-2.el6.i686 (epel)
               omniORB = 4.1.6-2.el6


    Transaction Check Error:
      file /usr/lib64/liblog4cxx.so.10.0.0 from install of apache-log4cxx-0.10.0-2.x86_64 conflicts with file from package log4cxx-0.10.0-13.el6.x86_64

Another common error is that the installation process is aborted because
the RPMs distributed by REDHAWK are not signed. You will see messages
such as:

    Package omniORBpy-debuginfo-3.0-0.2.el6.x86_64.rpm is not signed

### Solution

#### Resolving EPEL incompatibilities during install

Although yum will recommend that you use the `--skip-broken` flag, in
general this won't create a successful installation because many
necessary packages won't be installed.

First clean out any existing omniORB package installs so that your
installation is in a fresh state.

    $ sudo yum erase 'omniORB*' log4cxx

If this command fails, you system has additional software installed on
it and you won't easily be able install both REDHAWK and this software
together. Because the specific resolution of this issue will vary
depending on you installation, it is impossible to define the specific
solution that is required.

If you are using the `localinstall` method, as described in the official
REDHAWK documentation you should be able to successfully perform the
dependency installation:

    $ sudo yum localinstall --nogpgcheck *.rpm

If you have configured your system to install REDHAWK and it's
dependencies from a yum repo (i.e. you or your system administrator has
configured /etc/yum.repos.d to point to REDHAWK repositories) then you
need to use the `--disablerepo` flag to temporarily disable the EPEL
repository

    $ sudo yum groupinstall --disablerepo=epel "REDHAWK-ALL"

#### Resolving EPEL incompatibilities during update

When you run:

    $ sudo yum update

there can also be incompatibility errors between the REDHAWK
repositories and the EPEL repositories. Adding the `--disablerepo` flag
at this point would defeat the purpose of doing the update. When doing
updates it is generally going to be safe to use the `--skip-broken` flag

    $ sudo yum --skip-broken update

#### Resolving Package Signature Issues

Working around the package signature issue requires that you add the
`--nogpgcheck` flag to the `yum` command or the `--nosignature` flag to
the `rpm` command.

If you are using an `/etc/yum.repos.d` file to provide access to the
REDHAWK repositories you should add the `gpgcheck=0` flag to the
configuration file.

Only skip the GPG check if you have received the .rpms from a verified
source; by skipping the GPG check it is possible that an altered version
of the package has been provided to you that has intentional security
vulnerabilities introduced into it. **IMPORTANT:** It is highly
recommended that you verify the check-sum of your downloaded REDHAWK
repositories **before** you install them with the `--nogpgcheck` flag.

    $ sha1sum ~/redhawk-deps-yum-centos-6-x86_64.tar.gz
    fea91fc5c56c63b24480aff275578f192f677c79  /root/redhawk-deps-yum-centos-6-x86_64.tar.gz
    $ sha1sum ~/redhawk-yum-R.1.8.3-centos-6-x86_64.tar.gz 
    8547c80769ed5a99572530b99dbcddc2b081d9ff  /root/redhawk-yum-R.1.8.3-centos-6-x86_64.tar.gz

Verify the output values against those provided on the REDHAWK [download
page](http://redhawksdr.github.com/Documentation/download.html).

### Discussion

The "REDHAWK Dependency" repositories exist to provide packages for
software that isn't available in the standard REDHAT Enterprise Linux
(RHEL) or CentOS installations. The EPEL repository exists for the same
reason. Unfortunately, the two repositories have conflicts such that
when performing installations you may have to temporarily disable one or
the other. Future versions of REDHAWK will likely be compatible with the
EPEL repository reducing the possibility of conflicts; however,
conflicts could still be introduced through other repositories that are
added to the system. The techniques described above would still apply in
those situations.

The `yum` and `rpm` commands use GPG signatures to verify the source and
contents of an RPM before installing it. This provides a degree of
protection against malicious attackers introducing security
vulnerabilities through the software installation process. Currently the
REDHAWK RPMs are not signed so you *must* disable the GPG check when
installing them. As long as you verify the SHA-1 checksum of your
downloads (as shown above) you achieve a similar degree of protection
from tampered packages.

### See Also

-   `man yum`
-   `man rpm`
-   `man sha1sum`

