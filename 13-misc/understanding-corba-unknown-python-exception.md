Understanding omniORB.UNKNOWN\_PythonException
----------------------------------------------

### Problem

When making a CORBA call, from Python, you get a `CORBA.UNKNOWN`
exception.

    CORBA.UNKNOWN(omniORB.UNKNOWN_PythonException, CORBA.COMPLETED_MAYBE)

### Solution

This error occurs because the CORBA servant method raised an exception
that wasn't a valid exception defined in the IDL. This is a common
problem when servants are implemented in Python.

Let's consider an implementation of the `CF::Device::allocateCapacity()`

~~~~ {.idl}
boolean allocateCapacity (in CF::Properties capacities)
    raises (CF::Device::InvalidCapacity,
            CF::Device::InvalidState,
            CF::Device::InsufficientCapacity);
~~~~

The safe way to implement this interface is to use ensure that only
valid IDL exceptions can be thrown

~~~~ {.python .numberLines}
    def allocateCapacity(self, capacities):
        try:
            pass # Insert implementations
        except (CF.Device.InvalidCapacity,
                CF.Device.InvalidState,
                CF.Device.InsufficentCapacity), e:
            raise # These exceptions are valid
        except:
            logging.exception("Unexpected error")
            return False
~~~~

This pattern ensures that only valid IDL exceptions are thrown. Any
other exception is logged (via the Python logging framework).
