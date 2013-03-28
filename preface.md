%REDHAWK Cookbook

Preface
=======

Audience
--------

This is a book of REDHAWK "recipes"; that is, it provides step-by-step
solutions that demonstrate how to use, develop, and deploy effective
REDHAWK solutions. This book includes recipes for both nascent and
experienced developers, but it does not delve into the underlying theory
or details of REDHAWK nor does it teach the general aspects of
programming or system-administration. When necessary, references are
provided that will allow the curious reader to delve into the technical
nuances of the subject.

Conventions
-----------

All commands assume the `bash` shell, if you use `tcsh` you will
potentially need to make substitutions.

Command prompts that require root privileges are preceeded with the `#`
prompt, for example:

    # yum install redhawk

Alternately, the instructions may use the `sudo`:

    $ sudo yum install redhawk

Otherwise, command prompts are preceeded with the `$` prompt. The output
from a command, if any, will be presented without either prompts:

    $ nodeBooter -D
    INFO:DomainManager - Starting Domain Manager
    INFO:DomainManager - Starting ORB!

Sometime a command listing will include comments, which follow bash
syntax and are preceeded with `#`

    $ nodeBooter -D -domain MY_DOMAIN # changes the domain name to MY_DOMAIN

Source code is highlighted and includes line numbers for reference

~~~~ {.python .numberLines}
from omniORB import CORBA

if __name__ == "__main__":
    orb = CORBA.ORB_init()
~~~~

When it's necessary to edit a file the gedit program will be used for
the example, although you are free to use any text editor of your
choosing (i.e. vi, emacs, etc.).

    $ sudo gedit /etc/omniORB.cfg

Changes to the file will be described using unified diff format. Adding
lines will appear with a leading `+`

~~~~ {.diff}
@@ @@
+endPoint = giop:tcp:
+endPoint = giop:unix:
~~~~

Deleting lines will appear with a leading `-`

~~~~ {.diff}
@@ @@
-DefaultInitRef = corbaloc::
~~~~

And modified lines will appear with both:

~~~~ {.diff}
@@ @@
-giopMaxMsgSize = 2097152
+giopMaxMsgSize = 10485760
~~~~

When referring to user-interfaces, the element to be acted upon will be
presented in **bold** font, for example:

-   Click **OK**
-   Expand **Target SDR**, click **Components**
-   In the **Domain** box, type a domain name

Source-code, commands, and file names will be presented in `monospace`
font.

\newpage
