Python Property Helpers
----------------------


### Problem

You want to work with Properties in a python component


### Solution

The python library within REDHAWK contains some property helpers that can be very useful for any python components that will be dealing with other CF.Resources configure() and query() call.  

In REDHAWK all properties are of type CF.DataType wich has an id string and a value that is a CORBA any.  All components have a query() and configure() interface that take and return sequences of CF.DataTypes call CF.Properties.  In the REDHAWK python properties module, properties can be converted to a dictionary where the property id is the dictionary key and the property value is the dictionary value.   

First import the properties module

    >>> import ossie.properties as props

Take for example a component with two simple properties, a float called 'mySimple_float' and 'mySimple_sting'.  When the component is queried it will return:

    >>> some_props 
    [ossie.cf.CF.DataType(id='mySimple_float', value=CORBA.Any(CORBA.TC_float, 1.100000023841858)), ossie.cf.CF.DataType(id='mySimple_string', value=CORBA.Any(CORBA.TC_string, 'abc'))]

To convert these properties to a python dictionary

    >>> myDict = props.props_to_dict(some_props)
    {'mySimple_float': 1.100000023841858, 'mySimple_string': 'abc'}

The properties module will read the typecode of the CORBA any value and convert the value of any simple properties to the appropriate python basic type

    >>> type(myDict['mySimple_float'])
    <type 'float'>

    >>> type(myDict['mySimple_string'])
    <type 'str'>

sequence properties will become lists

    >>> some_props
    [ossie.cf.CF.DataType(id='mySeq_float', value=CORBA.Any(orb.create_sequence_tc(bound=0, element_type=CORBA.TC_float), [1.2000000476837158, 3.4000000953674316, 5.599999904632568]))]
    >>> props.props_to_dict(some_props)
    {'mySeq_float': [1.2000000476837158, 3.4000000953674316, 5.599999904632568]}

struct properties will become dictionaries

    >>> some_props
    [ossie.cf.CF.DataType(id='myStruct', value=CORBA.Any(CORBA.TypeCode("IDL:CF/Properties:1.0"), [ossie.cf.CF.DataType(id='myFloat', value=CORBA.Any(CORBA.TC_float, 9.100000381469727)), ossie.cf.CF.DataType(id='myLong', value=CORBA.Any(CORBA.TC_long, 15))]))]
    >>> props.props_to_dict(some_props)
    {'myStruct': {'myLong': 15, 'myFloat': 9.100000381469727}}

struct sequence properties will become lists of dictionaries

    >>> some_props
    [ossie.cf.CF.DataType(id='myStructSeq', value=CORBA.Any(CORBA.TypeCode("IDL:omg.org/CORBA/AnySeq:1.0"), [CORBA.Any(CORBA.TypeCode("IDL:CF/Properties:1.0"), [ossie.cf.CF.DataType(id='myChar', value=CORBA.Any(CORBA.TC_char, 'g')), ossie.cf.CF.DataType(id='myString', value=CORBA.Any(CORBA.TC_string, 'qwerty'))]), CORBA.Any(CORBA.TypeCode("IDL:CF/Properties:1.0"), [ossie.cf.CF.DataType(id='myChar', value=CORBA.Any(CORBA.TC_char, 'h')), ossie.cf.CF.DataType(id='myString', value=CORBA.Any(CORBA.TC_string, 'uiop'))])]))]
    >>> props.props_to_dict(some_props)
    {'myStructSeq': [{'myString': 'qwerty', 'myChar': 'g'}, {'myString': 'uiop', 'myChar': 'h'}]}

A set of different property types can be converted at the same time.

    >>> some_props
    [ossie.cf.CF.DataType(id='mySeq_float', value=CORBA.Any(orb.create_sequence_tc(bound=0, element_type=CORBA.TC_float), [1.2000000476837158, 3.4000000953674316, 5.599999904632568])), ossie.cf.CF.DataType(id='mySimple_float', value=CORBA.Any(CORBA.TC_float, 1.100000023841858)), ossie.cf.CF.DataType(id='mySimple_string', value=CORBA.Any(CORBA.TC_string, 'abc')), ossie.cf.CF.DataType(id='mySimple_long', value=CORBA.Any(CORBA.TC_long, 20)), ossie.cf.CF.DataType(id='myStruct', value=CORBA.Any(CORBA.TypeCode("IDL:CF/Properties:1.0"), [ossie.cf.CF.DataType(id='myFloat', value=CORBA.Any(CORBA.TC_float, 9.100000381469727)), ossie.cf.CF.DataType(id='myLong', value=CORBA.Any(CORBA.TC_long, 15))])), ossie.cf.CF.DataType(id='myStructSeq', value=CORBA.Any(CORBA.TypeCode("IDL:omg.org/CORBA/AnySeq:1.0"), [CORBA.Any(CORBA.TypeCode("IDL:CF/Properties:1.0"), [ossie.cf.CF.DataType(id='myChar', value=CORBA.Any(CORBA.TC_char, 'b')), ossie.cf.CF.DataType(id='myString', value=CORBA.Any(CORBA.TC_string, 'qwerty'))]), CORBA.Any(CORBA.TypeCode("IDL:CF/Properties:1.0"), [ossie.cf.CF.DataType(id='myChar', value=CORBA.Any(CORBA.TC_char, 'a')), ossie.cf.CF.DataType(id='myString', value=CORBA.Any(CORBA.TC_string, 'uiop'))])]))]
    >>> props.props_to_dict(some_props)
    {'mySeq_float': [1.2000000476837158, 3.4000000953674316, 5.599999904632568], 'mySimple_float': 1.100000023841858, 'mySimple_string': 'abc', 'mySimple_long': 20, 'myStruct': {'myLong': 15, 'myFloat': 9.100000381469727}, 'myStructSeq': [{'myString': 'qwerty', 'myChar': 'b'}, {'myString': 'uiop', 'myChar': 'a'}]}


The opposite transformation can also be performed; properties can also be created from dictionaries.

    >>> props.props_from_dict({'aprop':5.0,'bprop':7})
    [ossie.cf.CF.DataType(id='bprop', value=CORBA.Any(CORBA.TC_long, 7)), ossie.cf.CF.DataType(id='aprop', value=CORBA.Any(CORBA.TC_double, 5.0))

    >>> props.props_from_dict({'myStructSeq': [{'myString': 'qwerty', 'myChar': 'b'}, {'myString': 'uiop', 'myChar': 'a'}]})
    [ossie.cf.CF.DataType(id='myStructSeq', value=CORBA.Any(orb.create_sequence_tc(bound=0, element_type=orb.create_sequence_tc(bound=0, element_type=CORBA.TypeCode("IDL:CF/DataType:1.0"))), [[ossie.cf.CF.DataType(id='myString', value=CORBA.Any(CORBA.TC_string, 'qwerty')), ossie.cf.CF.DataType(id='myChar', value=CORBA.Any(CORBA.TC_string, 'b'))], [ossie.cf.CF.DataType(id='myString', value=CORBA.Any(CORBA.TC_string, 'uiop')), ossie.cf.CF.DataType(id='myChar', value=CORBA.Any(CORBA.TC_string, 'a'))]]))]




