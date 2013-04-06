Understanding CORBA.BAD\_PARAM exceptions
-----------------------------------------

### Problem

When making a CORBA call, from Python, you get a
`CORBA.BAD_PARAM_WrongPythonType` exception.

    CORBA.BAD_PARAM(omniORB.BAD_PARAM_WrongPythonType, CORBA.COMPLETED_NO)

or

    CORBA.BAD_PARAM(omniORB.BAD_PARAM_WrongPythonType, CORBA.COMPLETED_MAYBE)

### Solution

This error occurs because either you called the method with invalid
arguments or it returned invalid arguments. In nearly all cases, you can
determine the source of the error by looking at the returned code. If
the code is `COMPLETED_NO` then the problem is with the arguments being
passed to the call. If the code is `COMPLETED_MAYBE` then the problems
is with the return value from the method.

When you receive a `COMPLETED_NO` you will need to check the type of all
the arguments that were passed to the method. Let's consider the
`BULKIO::updateSRI` as an example. It is defined as:

~~~~ {.idl}
struct PrecisionUTCTime {
    short tcmode;       /* timecode mode */
    short tcstatus;     /* timecode status */
    double toff;        /* Fractional sample offset */
    double twsec;       /* J1970 GMT */
    double tfsec;       /* 0.0 to 1.0 */

};

interface dataDouble : ProvidesPortStatisticsProvider, updateSRI {
    void pushPacket(in PortTypes::DoubleSequence data,
                    in PrecisionUTCTime T,
                    in boolean EOS,
                    in string streamID);
};
~~~~

Here is some example code that will cause a BAD\_PARAM error because the
following arguments have invalid types: the `tcmode` field within the
`PrecisionUTCTime` structure, the `EOS` flag, and the `streamID`.

~~~~ {.python .numberLines}
T = BULKIO.PrecisionUTCTime("TCM_OFF", 0, 0.0, 0.0, 0.0)
D = [1.0, 2.0, 3.0]
EOS = "true"
streamId = None
t.pushPacket(D, T, EOS, streamId)
'''
Traceback (most recent call last):
  File in <module>
    t.pushPacket(D, T, EOS, streamId)
  File "/usr/redhawk/core/lib/python/bulkio/bulkioInterfaces/bio_dataFloat_idl.py", line 71, in pushPacket
    return _omnipy.invoke(self, "pushPacket", _0_BULKIO.dataFloat._d_pushPacket, args)
omniORB.CORBA.BAD_PARAM: CORBA.BAD_PARAM(omniORB.BAD_PARAM_WrongPythonType, CORBA.COMPLETED_NO)
'''
~~~~

Unfortunately, the stack trace does not display the values of the
arguments so it's difficult to isolate the source of the error. Using
this function, we can get more insight into the source of the error:

~~~~ {.python .numberLines}
def handle_BAD_PARAM(e):
    traceback.print_exc()
    if e.completed == CORBA.COMPLETED_NO:
        frames = inspect.trace()
        argvalues = inspect.getargvalues(frames[1][0])
        print "  Error occurred in CORBA client arguments."
        print "  Values Provided:"
        print "    " + ", ".join([str(x) for x in argvalues.locals['args']])
    else:
        traceback.print_exc()
        print "  Error occurred in CORBA servant return value."
~~~~

When you use the `handle_BAD_PARAM` function, it helps isolate the
source of the error because you can see the actual values that were
passed.

~~~~ {.python .numberLines}
try:
    t.pushPacket(D, T, EOS, streamId)
except CORBA.BAD_PARAM, e:
    handle_BAD_PARAM(e)
'''
Traceback (most recent call last):
  File in <module>
    t.pushPacket(D, T, EOS, streamId)
  File "/usr/redhawk/core/lib/python/bulkio/bulkioInterfaces/bio_dataFloat_idl.py", line 71, in pushPacket
    return _omnipy.invoke(self, "pushPacket", _0_BULKIO.dataFloat._d_pushPacket, args)
BAD_PARAM: CORBA.BAD_PARAM(omniORB.BAD_PARAM_WrongPythonType, CORBA.COMPLETED_NO)
  Error occurred in CORBA client arguments.
  Values Provided:
    [1.0, 2.0, 3.0], bulkio.bulkioInterfaces.BULKIO.PrecisionUTCTime(tcmode='TCM_OFF', tcstatus=0, toff=0.0, twsec=0.0, tfsec=0.0), true, None
~~~~

Debugging `BAD_PARAM` errors with `COMPLETED_MAYBE` is more difficult
because the servant-side does not experience an error and the
client-side cannot display the returned value. A good coding pattern to
establish is to assert the types of your return values, for example:

~~~~ {.python .numberLines}
class Example(CF__POA.Device):
    def allocateCapacity(self, allocateCapacities):
        success = False
        ... do some code ...
        assert(isintance(success, bool))
        return success
~~~~

### Discussion

Unlike Python, CORBA mandates that calls are made via strongly-typed
interfaces. When a Python type cannot be coerced to the correct CORBA
type you will receive a BAD\_PARAM\_WrongPythonType error. The mapping
between CORBA types and their Python equivalents is defined in the
*CORBA Python Language Mapping*.

### See Also

-   [CORBA Python Language
    Mapping](http://www.omg.org/spec/PYTH/1.2/PDF)
-   [Strong Typing](http://en.wikipedia.org/wiki/Strong_typing)

