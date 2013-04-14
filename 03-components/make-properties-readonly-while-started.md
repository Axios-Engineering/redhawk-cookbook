Making Component Properties Read-only While Started
---------------------------------------------------

### Problem

You want to allow your component to accept configuration changes after
it is launched but prevent one or more properties from being modified
while the component is running (i.e. it has been started via `start()`.

### Solution

For components that are implemented in Python, you can override the
validation function to return False if the component has started. If a
configuration is attempted while the component has started an
`InvalidConfiguation` error will be thrown.

~~~~ {.python .numberLines}
class yourcomp_python_i(yourcomp_python_base):

    prevent_cfg_while_started = lambda self, v: not self._get_started()

    # Prevent prop1 and prop2 from being modified while the component
    # is running.
    yourcomp_python_base.prop1.fval = prevent_cfg_while_started
    yourcomp_python_base.prop2.fval = prevent_cfg_while_started

    def initialize(self):
        yourcomp_python_base.initialize(self)

    # ... the rest of the component implementation
~~~~

In C++ and Java, it is a bit more complicated because the baseline (as
of 1.8.3) does not include the ability to intercept the configure calls.
To achieve a similar effect in these languages you must override the
`configure()` implementation to achieve the desired behavior.

For C++, override the `validate` and `configure` methods:

~~~~ {.cpp .numberLines}
// In 1.8.3 validate exists as a base-class method, but isn't called
// so we override both configure() and validate() to get the desired
// behavior.
void yourcomp_cpp_i::validate(CF::Properties property,
                              CF::Properties& validProps,
                              CF::Properties& invalidProps)
{
    for (CORBA::ULong ii = 0; ii < property.length (); ++ii) {
        std::string id((const char*)property[ii].id);
        if (_started) {
            if (id == "prop1") {
                CORBA::ULong count = invalidProps.length();
                invalidProps.length(count + 1);
                invalidProps[count].id = property[ii].id;
                invalidProps[count].value = property[ii].value;
            }
        }
    }

    if (invalidProps.length() > 0) {
        throw CF::PropertySet::InvalidConfiguration(
            "Properties failed validation",
             invalidProps);
    }
}

void yourcomp_cpp_i::configure (const CF::Properties& configProperties)
    throw (CF::PropertySet::PartialConfiguration,
           CF::PropertySet::InvalidConfiguration,
           CORBA::SystemException)
{
    CF::Properties validProperties;
    CF::Properties invalidProperties;
    validate(configProperties, validProperties, invalidProperties);

    PropertySet_impl::configure(configProperties);
}
~~~~

For Java, override the `configure` method:

~~~~ {.java .numberLines}
private static final HashSet<String> readonly_while_started = new HashSet<String>();
{
    readonly_while_started.add("prop1");
}

@Override
public void configure(DataType[] configProperties)
                      throws InvalidConfiguration, PartialConfiguration {
    if (this.started()) {
    final ArrayList<DataType> readonlyProperties = new ArrayList<DataType>();
    for (final DataType configProp : configProperties) {
        if (readonly_while_started.contains(configProp.id)) {
        readonlyProperties.add(configProp);
        }
    }

    if (readonlyProperties.size() != 0) {
        throw new InvalidConfiguration(
        "Attempt to configure readonly properties",
        readonlyProperties.toArray(new DataType[0]));
    }
    }

    super.configure(configProperties);
}
~~~~

### Discussion

When implementing components it is often desirable to allow the
component to be configured dynamically after it has been launched. By
default, properties that are "configurable" can be configured at any
point in time after the component has been initialized. Ideally, the
component would be able to respond correctly to configuration changes at
any time; however, when the component cannot correctly deal with a
configuration request it should raise an `InvalidConfiguration` or
`ParitalConfiguration` error to indicate that the configuration request
was not honored.

It's always a good idea to test your components behavior, the follow
snippet can be added to the components unit test to verify that the
component behavior works as expected:

~~~~ {.python .numberLines}
# Verify that we can configure before start
self.comp.configure(props_from_dict({"prop1": "Hello"}))

self.comp.start()

try:
    self.comp.configure(props_from_dict({"prop1": "World"}))
except CF.PropertySet.InvalidConfiguration:
    pass
else:
    self.assert_("Expected InvalidConfiguration error")

self.comp.stop()

# Verify that we can configure after stop
self.comp.configure(props_from_dict({"prop1": "Goodbye"}))
~~~~
