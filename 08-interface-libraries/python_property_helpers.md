Python Property Helpers
-----------------------

### Problem

You want to call `configure()` or `query()` from Python without having
to directly manipulate properties using CF::Properties.

### Solution

REDHAWK provides a simple API with the core-framework that allows easy
manipulation of properties by converting them to and from Python lists
and dictionaries. While these utility functions can be used in a broad
range of applications, they are particularly useful when dealing with
the `configure()` and `query()` calls.

Import the two utility methods:

~~~~ {.python .numberLines}
from ossie.properties import props_to_dict, props_from_dict
~~~~

As their name implies, they convert a `CF::Properties` to or from a
python dictionary. For example, consider querying a component with two
`<simple>` properties:

~~~~ {.python .numberLines}
props = comp.query([])
print props
'''
[ossie.cf.CF.DataType(id='mySimple_float',
                      value=CORBA.Any(CORBA.TC_float, 1.100000023841858)),
 ossie.cf.CF.DataType(id='mySimple_string',
                      value=CORBA.Any(CORBA.TC_string, 'abc'))]
'''
props = props_to_dict(props)
print props
'''
{'mySimple_float': 1.100000023841858, 'mySimple_string': 'abc'}
'''
~~~~

Similarly, `<simplesequence>` properties become lists:

~~~~ {.python .numberLines}
props = comp.query([])
print props
'''
[ossie.cf.CF.DataType(id='mySeq_float',
  value=CORBA.Any(orb.create_sequence_tc(bound=0, element_type=CORBA.TC_float),
                  [1.2000000476837158, 3.4000000953674316, 5.599999904632568]))]
'''
props = props_to_dict(props)
print props
'''
{'mySeq_float': [1.2000000476837158, 3.4000000953674316, 5.599999904632568]}
'''
~~~~

`<struct>` properties become dictionaries

~~~~ {.python .numberLines}
props = comp.query([])
print props
'''
[ossie.cf.CF.DataType(id='myStruct',
 value=CORBA.Any(CORBA.TypeCode("IDL:CF/Properties:1.0"),
 [ossie.cf.CF.DataType(id='myFloat', value=CORBA.Any(CORBA.TC_float, 9.100000381469727)),
  ossie.cf.CF.DataType(id='myLong', value=CORBA.Any(CORBA.TC_long, 15))]))]
'''
props = props_to_dict(props)
print props
'''
{'myStruct': {'myLong': 15, 'myFloat': 9.100000381469727}}
'''
~~~~

`<structsequence>` properties are a list of dictionaries:

~~~~ {.python .numberLines}
props = comp.query([])
print props
'''
[ossie.cf.CF.DataType(id='myStructSeq',
 value=CORBA.Any(CORBA.TypeCode("IDL:omg.org/CORBA/AnySeq:1.0"),
 [CORBA.Any(CORBA.TypeCode("IDL:CF/Properties:1.0"),
  [ossie.cf.CF.DataType(id='myChar',
   value=CORBA.Any(CORBA.TC_char, 'g')),
   ossie.cf.CF.DataType(id='myString', value=CORBA.Any(CORBA.TC_string, 'qwerty'))]),
  CORBA.Any(CORBA.TypeCode("IDL:CF/Properties:1.0"),
  [ossie.cf.CF.DataType(id='myChar', value=CORBA.Any(CORBA.TC_char, 'h')),
   ossie.cf.CF.DataType(id='myString', value=CORBA.Any(CORBA.TC_string, 'uiop'))])]))]
'''
props = props_to_dict(some_props)
print props
'''
{'myStructSeq': [{'myString': 'qwerty', 'myChar': 'g'}, {'myString': 'uiop', 'myChar': 'h'}]}
'''
~~~~

The opposite transformation can also be performed; a `CF::Properties`
can be created from dictionaries.

~~~~ {.python .numberLines}
props = props_from_dict({'aprop': 5.0,'bprop': 7})

print props
'''
[ossie.cf.CF.DataType(id='bprop',
                      value=CORBA.Any(CORBA.TC_long, 7)),
 ossie.cf.CF.DataType(id='aprop',
                      value=CORBA.Any(CORBA.TC_double, 5.0))
'''
comp.configure(props)
~~~~

These two methods are especially useful when manipulating elements
within a complex property type, for example:

~~~~ {.python .numberLines}
props = props_to_dict(comp.query([]))
props['mySimple_float'] = 1.0
props['myStruct']['myLong'] = 100
props['myStructSeq'][1]['myChar'] = "x"
props['mySeq_float'].append(55.0)
comp.configure(props_from_dict(props))
~~~~

### Discussion

In SCA (and thus REDHAWK) objects that implement the `CF::PropertySet`
interface will provide `configure()` and `query()` methods.

~~~~ {.idl}
interface PropertySet {
    struct DataType {
        string id;
        any value;
    };
    typedef sequence <DataType> Properties;

    void configure (in CF::Properties configProperties);
    void query (inout CF::Properties configProperties);
};
~~~~

Working directly with the `CF::Properties` sequence is tedious, for
`<simple>` properties you can use the following code:

~~~~ {.python .numberLines}
def get_property(props, id_):
    for prop in props:
        if prop.id == id_:
            return any.from_any(prop.value)

def set_property(props, id_, value):
    props.append(CF.DataType(id_, any.to_any(value)))
~~~~

Working with the complex property types, such as `<struct>` and
`<structsequence>` are more complex (see the implementation of
`props_to_dict` and `props_from_dict` for details).

When converting from `CF::Properties` to a dictionary, the typecode of
the CORBA any value will be set the type of the python type. When
converting from a dictionary to a `CF::Properties` the Python types will
be used to infer the CORBA types. You must take care to ensure that the
type you pass matches that of the defined property.

For example, if you defined a property:

~~~~ {.XML}
<simple id="frequency" mode="readwrite" type="long">
  <units>Hz</units>
  <kind kindtype="configure"/>
  <action type="external"/>
</simple>
~~~~

Configuring it with an incorrect type will potentially cause problems
(depending on the implementation of the component):

~~~~ {.python .numberLines}
props = {"frequency": "xyz"}
props = props_from_dict(props)
try:
    comp.configure(props)
except Exception, e:
    # A variety of different exceptions could be thrown
    # if you don't follow the correct types
    print e
~~~~

Correctly constructed components should throw either a
`InvalidConfiguration` or `PartialConfiguration` error.
