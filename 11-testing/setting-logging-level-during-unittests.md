Setting Logging Level During Unit Tests
---------------------------------------

### Problem

You want to run your component or device in a unit test with a logging
level that is higher or lower than the default.

### Solution

All REDHAWK component and devices support logging via log4cxx, log4j, or
the python logging module. By default, only logging messages of INFO or
higher are displayed. While running unittests, it is often desirable to
have a higher level of logging displayed. This can easily be
accomplished by setting the DEBUG\_LEVEL execparam in the unit test. For
example:

~~~~ {.python .numberLines}
execparams = self.getPropertySet(kinds=("execparam",), modes=("readwrite", "writeonly"), includeNil=False)
execparams = dict([(x.id, any.from_any(x.value)) for x in execparams])
execparams["DEBUG_LEVEL"] = 4
self.launch(execparams)
~~~~

When running a component or device within the IDE Sandbox, you can
change the `DEBUG_LEVEL` by altering the run configuration.

1.  Select **Run \> Run Configurations...**
2.  Navigate to the components or devices configuration
3.  Select the **Arguments** tab
4.  Provide an argument of `DEBUG_LEVEL 4`
5.  Click **Apply**

![Altering DEBUG\_LEVEL in IDE
Sandbox](figures/setting_debug_level_in_ide.png)

### Discussion

The `DEBUG_LEVEL` is an implicit execparam (i.e. all components and
devices have a DEBUG\_LEVEL even if not explicitly declared in the PRF
file). The DEBUG\_LEVEL controls which messages are emitted by the
logging framework. `DEBUG_LEVEL` specifies the *maximum* message that
will be shown, in other words higher `DEBUG_LEVEL`s will produce more
messages. Valid values are:

-   0 - CRITICAL
-   1 - ERROR
-   2 - WARNING (**default**)
-   3 - INFO
-   4 - DEBUG
-   5 - TRACE

When testing your components, it is preferable to change the
`DEBUG_LEVEL` in the unittest or run configuration instead of changing
the values within the source code itself.
