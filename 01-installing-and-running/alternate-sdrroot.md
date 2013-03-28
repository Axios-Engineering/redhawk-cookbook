Running REDHAWK with an alternate $SDRROOT
------------------------------------------

### Problem

You want to run REDHAWK with an $SDRROOT other than the sytem default.

### Solution

Decide on a location for your SDRROOT, for instance `~/sdr`:

    $ export SDRROOT=~/sdr

Then make the appropriate folder structure

    $ mkdir -p $SDRROOT/{dom/components,dom/waveforms,dom/domain,dev/devices,dev/nodes}

And link to the DomainManager and DeviceManager binaries

    $ ln -s /var/redhawk/sdr/dom/mgr $SDRROOT/dom/mgr
    $ ln -s /var/redhawk/sdr/dev/mgr $SDRROOT/dev/mgr

Finally, prepare your domain by copy the *DomainManager* template:

    $ cp /var/redhawk/sdr/dom/domain/DomainManager.dmd.xml.template \
         $SDRROOT/dom/domain/DomainManager.dmd.xml

And then editing the template per the directions in the file:

    $ gedit $SDRROOT/dom/domain/DomainManager.dmd.xml

To ensure that your `$SDRROOT` preference is preserved, you will want to
add it into your \~/.bashrc (or equivalent file).

### Discussion

There are a variety of reasons that you may want to use an `$SDRROOT`
other than the default `/var/redhawk/sdr` folder. The most common is
that you don't have write permissions to the default `$SDRROOT`. Another
reason is that you are on a multi-user system and you don't want to have
your development activites interact with other developers on the same
system.
