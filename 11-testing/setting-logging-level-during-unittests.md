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

This shows all messages at level 4 (DEBUG) or higher.
