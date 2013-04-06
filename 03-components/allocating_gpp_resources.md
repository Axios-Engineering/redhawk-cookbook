Allocating GPP resources From a Component
-----------------------------------------

### Problem

You want to allocate GPP resources with the components that are launched
so that when one GPP is full components will be launched on other GPPs.

### Solution

REDHAWK allocates dependencies specified in components on the devices
that load and execute those components. You can add dependencies to your
component on the **Implementations** tab when editing a components
`spd.xml` file. Within the **Dependencies** section you will see three
different types of dependencies:

-   **OS** - Declares the valid operating systems that the component
    implementation supports. For REDHAWK this will always be Linux.
-   **Processor(s)** - Declares the valid processors that the component
    implementation supports. For REDHAWK this will be x86, x86\_64, or
    both.
-   **Dependency** - Declares other allocation or matching properties
    that the component implementation requires.

![Editing Dependencies in the IDE](figures/gpp_depend_ide.png)

To add a new dependency, click **Add...** within the **Dependency**
section. This will display the **Dependency Wizard** that will help you
create the dependency:

![The IDE Dependency Wizard](figures/ide_dependency_wizard.png)

You can use the **Browse...** functionality to help find the property
you want to depend on. For example, to allocate two processing
core on the GPP select `GPP:load_capacity`.

![Adding GPP:load\_capacity
Dependency](figures/dependency_property_selection.png)

This will insert the following XML into the components `spd.xml`:

~~~~ {.XML}
<dependency type="allocation">
  <propertyref refid="DCE:72c1c4a9-2bcf-49c5-bafd-ae2c1d567056" value="2.0"/>
</dependency>
~~~~

When the component is deployed, the `ApplicationFactory` will use the
`allocateCapacity()` call to find a device within the domain that can
provide 2.0 load capacity. Other common GPP properties include: memory,
network ingress and egress bandwidth, hard-disk space, and such.

Another typical dependency is a "matching" dependency. Unlike
"allocation" properties a "matching" property does not call
`allocateCapacity()`; the matching is performed by the
`ApplicationFactory` using the action as defined in the devices
`prf.xml`. See section D.4.1.1.7 of *SCA 2.2.2 Appendix D* for full
details of how matching properties are defined.

The most common matching property is "DeviceKind" (or "device\_kind").
It is used to restrict the component to loading or using only devices of
a specific type. For example you might specify "GPU" to indicate the
component ran on a GPU rather than a GPP.

~~~~ {.XML}
<dependency type="matching">
  <propertyref refid="DCE:cdc5ee18-7ceb-4ae6-bf4c-31f983179b4d" value="GPU"/>
</dependency>
~~~~

In some cases the amount of a resource that is need could be change for
each time the component is executed based on how it is being used. In
those cases, you can make the values of the allocation a derivative of a
component property. Let's say that your component will store one second
of data in it at all times so the memory it uses is related to the
sample rate (memoryMB = samplerate/1000000). To specify this type of
relationship use the `__MATH__` operator in the value field. The math
function takes the a scalar value, a property id from the components
PRF, and an math operator.

~~~~ {.XML}
<dependency type="allocation">
  <propertyref refid="DCE:8dcef419-b440-4bcf-b893-cab79b6024fb"
               value="__MATH__(0.1,sample_rate,*)"/>
</dependency>
~~~~

### Discussion

If all your components specify their required resources then when one of
those resources runs out, the application factory will fail to allocate
your component on that device and will launch it on another GPP. REDHAWK
provides a convenient way to specify the amount of resources a component
will need on a GPP. It is up to the component designer to test and
measure what those amounts are.
