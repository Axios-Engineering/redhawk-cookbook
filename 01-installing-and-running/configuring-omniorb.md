Configuring OmniORB
-------------------

### Problem

You want to customize or optimize the default OmniORB configuration used
by REDHAWK.

### Solution

OmniORB provides a bewildering array of bells-and-whistles that allow
you to fully-customize it's behavior. There are are small-set of options
that you will want to pay specific attention to when using REDHAWK.

The system omniORB configuration is typically located at
`/etc/omniORB.cfg` and will require `root` priveledges to edit

    sudo gedit /etc/omniORB.cfg

If you do not have `root` priveledges or do not want to modify the
system-defaults you can alter the sytem defaults in two-ways. The
easiest is to set the `$OMNIORB_CFG` variable to point to an alternate
file:

    $ cp /etc/omniORB.cfg $HOME/.redhawk-omniORB.cfg
    $ export OMNIORB_CONFIG=$HOME/.redhawk-omniORB.cfg

Or if you only have a few options you want to override, you can use set
them individually using environment variables:

    $ export ORBgiopMaxMsgsize=10485760

As with all environment variables, the changes will not persist unless
you add the `export` lines into your `~/.bashrc` or equivalent.

### Discussion

The standard REDHAWK installation assumes that you are configuring a
machine to use as a standalone development box; however, depending on
your system configuration or needs you may need to tweak one or more of
the settings.

The most common settings that REDHAWK users/developers change are:

***giopMaxMsgSize*** : The alters the maximum size (in bytes) that the
ORB will send in a single message. This will drastically affect CORBA
calls that send arrays of data, such as `BULKIO::data*::pushPacket()` or
`CF::File::read()`. To improve throughput you will want to send a large
amount of data during a single call, but this will increase latency
*and* potentially exceed the ORB's maximum message size. If the call
attempts to send (or return) data that exceeds the bounds of the
giopMaxMsgSize; calls that exceed the `giopMaxMsgSize` will fail with a
MARSHALL error. Unfortunately you cannot simply check the giopMaxMsgSize
and adjust the array to that size because the message size includes both
the message size includes the overhead (i.e. header) and all other
arguments or return values. When necessary, the safe approach is to
experimentally determine some approximate threshold below the
giopMaxMsgSize to mitigate (but not necessarily avoid) CORBA marshall
errors. Setting an extremely large `giopMaxMsgSize` (e.g. in the 100's
of MBytes) is generally an indication that you need to adjust the
implementation of your software.

***clientCallTimeOutPeriod*** : This alters how long a client will wait
for the servant to complete it's request. By default this value is set
to `0`, which indicates that the client will wait forever. For
development or experimentation this value is sufficent, but for
production systems this can cause deadlocks if unexpected errors occur
that cause the server side to get stuck in a loop. In general, it's a
good idea to increase this value (e.g. 60 sec.) so that when things go
wrong a `TIMEOUT` exception is raised on the client-side. Setting an
extremely large `clientCallTimeOutPeriod` (e.g. 300 sec.) ig generally
an indicatation that you need to alter the implementation of your
software so that long running operations are performed in a background
thread and the client is notified when the operation is complete.

***InitRef*** : The `InitRef` allows CORBA programs to "bootstrap" and
find various CORBA servants, such as the *NameServer* and *EventServer*.
The default REDHAWK configuration assumes that you will be developing
and deploying on a single host and sets the `InitRef` for those services
to point to `localhost` or `127.0.0.1`.

***endPoint, endPointPublish*** : A CORBA servant can use and publish
multiple end points (i.e. transports that allow the client to talk to
the server). The default configuration will, at a minimum, support TCP
connections. A common optimization used with REDHAWK development is to
include support for unix-domain-sockets via the `giop:unix:` end point.
This transport will improve BULKIO data transfer performance when both
the client and server are colocated on the same machine. Another common
situation is that a machine has multiple ethernet adapters and IP
addresses and you need to use `endPointPublish` to ensure that the
proper IP address is exposed to the client.

### See Also

-   [OmniORB
    Documentation](http://omniorb.sourceforge.net/omni41/omniORB/)

