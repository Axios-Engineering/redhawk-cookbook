Allocating GPP resources From a Component
---------------------


### Problem

You want to allocate GPP resources with the components that are launched so that when one GPP is full components will be launched on other GPPs.

### Solution

REDHAWK allocates dependencies specified in components on the devices that load and execute those components.  You can add dependencies to your component on the implementation tab from the IDE.  Common GPP properties to allocate include, CPU load capacity, memory, and network ingress and egress bandwidth.   

![Editing Dependencies in the IDE](../gpp_depend_ide/pic.png)

After using the IDE to add the implementation dependencies you can view the changes in the .spd.xml

    <dependency type="allocation">
      <propertyref refid="DCE:72c1c4a9-2bcf-49c5-bafd-ae2c1d567056" value="0.5"/>
    </dependency>
    <dependency type="allocation">
      <propertyref refid="DCE:8dcef419-b440-4bcf-b893-cab79b6024fb" value="10"/>
    </dependency>
    <dependency type="matching">
      <propertyref refid="DCE:cdc5ee18-7ceb-4ae6-bf4c-31f983179b4d" value="GPP"/>
    </dependency>

The DCE values correspond to the allocation properties on the GPP.  In this case the properties are load capacity, memory (in Megabytes) and Device Kind.  Device Kind is a property used to help find the correct type of device you want to execute on.  For example you might specify "GPU" to indicate the component ran on a GPU rather than a GPP.  For properties allocation that can be satisfied by simple matching like device kind the type will be specified as "matching."  For properties that use up a resources the type will be "allocation."

In some cases the amount of a resource that is need could be change for each time the component is executed based on how it is being used.  In those cases, you can make the values of the allocation a derivative of a component property.  Let's say that your component will store one second of data in it at all times so the memory it uses is related to the sample rate (memoryMB = samplerate/1000000).  To specify this type of relationship use the "__math__" operator in the value field.  The math function takes the property name, a simple value and an operator.  

        <dependency type="allocation">
      <propertyref refid="DCE:8dcef419-b440-4bcf-b893-cab79b6024fb" value="__MATH__(0.1,sample_rate,*)"/>
    </dependency>



### Discussion

If all your components specify their required resources then when one of those resources runs out, the application factory will fail to allocate your component on that device and will launch it on another GPP.  REDHAWK provides a convenient way to specify the amount of resources a component will need on a GPP.  It is up to the component designer to test and measure what those amounts are.



