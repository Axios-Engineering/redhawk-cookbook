Running Multiple Domains
------------------------

### Problem

You want to run multiple domains; when you attempt to do so you get one
of the following errors:

    $ nodeBooter -D
    omniORB: Failed to bind to address :: port 5678. Address in use?
    omniORB: Error: Unable to create an endpoint of this description: giop:tcp::5678
    FATAL:DomainManager - Failed to initialize the POA. Is there a Domain Manager already running?

Or:

    $ nodeBooter -D
    INFO:DomainManager - Starting Domain Manager
    FATAL:DomainManager - A DomainManager is already running as REDHAWK_DEV/REDHAWK_DEV

### Solution

When running the *DomainManager* two things must be unique: the port
that the *DomainManager* uses for it's CORBA endpoint and the naming
context it uses on the CORBA *NameServer*.

When you receive a "Failed to bind to address" error, the quick solution
is to add the `--nopersist` flag when starting the `nodeBooter`:

    $ nodeBooter -D --nopersist

When you receive the "A DomainManager is already running" error, the
quick solution is to add the `--domainname` flag when starting the
`nodeBooter`:

    $ nodeBooter -D --domainname REDHAWK_DEV2

Or add both together:

    $ nodeBooter -D --nopersist --domainname REDHAWK_DEV2

Alternate approaches are discussed below.

### Discussion

Like all TCP servers, CORBA servants listen for incoming connections
using one or more TCP ports. By default, these ports are randomly
assigned and you do not need to configure them. For special
circumstances it becomes necessary to provide a "persistent" endpoint
for a CORBA servant. One such circumstance is when you want CORBA
clients to be able to continue using the previous object reference to
continue to talk to the server after restarts. In other words, when a
*DomainManager* is restarted the clients can continue to talk to it.

One aspect of creating a "persistent" endpoint is that it must be tied
to a specific port. By default, the REDHAWK *DomainManager* uses port
5678. Because a port can only be used by one process, the second
*DomainManager* will fail to launch. The `--nopersist` uses a random
port, so it won't conflict with any other *DomainManager*. For
development purposes, this is ideal (in fact the REDHAWK IDE always
launches domains in this manner). If you want to run multiple domains
with persistent endpoints you can use the `--ORBport` argument. You will
need to ensure that you select a port that isn't in use by other
processes.

In addition to running on a unique port, the *DomainManager* must be
uniquely named on the CORBA *NameServer*. The `--domainname` argument
temporarily changes the domain name and is sufficient to use when
developing or testing REDHAWK. For other purposes, it is better to alter
the `DomainManager.dmd.xml` file instead.
