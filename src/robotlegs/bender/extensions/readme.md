# Robotlegs Extensions

A selection of built-in extensions.

## Extensions Vs Bundles

An extension integrates a single utility or library into a Robotlegs context.

A bundle bundles up a selection of extensions and configurations into a single package.

# Writing An Extension

A Robotlegs extension should contain at least four things: an API, an implementation, an integration file and a readme.

The API and implementation files define the extension or utility itself.

The integration file defines how and when the extension is loaded into (and removed from) a Robotlegs context.

The readme file is the most important. It's the first thing that you write when you sit down to build an extension. It outlines your goals, the purpose of the extension and how the extension can be used:

http://tom.preston-werner.com/2010/08/23/readme-driven-development.html

If you can't sum up what the extension is and how it can be used in a readme file, then perhaps the scope of your extension is too big. In that case consider breaking it out into smaller, more focused extensions.

## The Extension/Integration Class (IExtension)

An extension implements the IExtension interface. When included into a context, that context is immediately passed through to the extend() method:

```as3
package robotlegs.extensions.superDuper
{
  public class SuperDuperExtension implements IExtension
  {
    public function extend(context:IContext):void
    {
      trace(this, " is being installed into ", context);
      // BEWARE: the context may not be fully initialized.
    }
  }
}
```

NOTE: The context instance provided to configureContext() may not be fully initialized.

### A Simple Extension

An extension might simply map a singleton:

```as3
public function extend(context:IContext):void
{
  context.injector.map(ISuperDuper).toSingleton(SuperDuper);
}
```

### Synchronizing With The Context

An extension can hook into various context lifecycle phases by adding state handlers to that context when the extension is installed:

```as3
public function extend(context:IContext):void
{
  if (context.initialized)
    throw new Error("This extension must be installed prior to context initialization");

  context.beforeInitializing(beforeInitializing);
  context.afterInitializing(afterInitializing);
}

private function beforeInitializing(phase:String, callback:Function):void
{
  // `before` handlers can accept a callback as the second argument
  // note: you *must* eventually call the callback or you will stall initialization
  trace("Doing some things before the context self initializes...");
  setTimeout(callback, 1000);
}

private function afterInitializing():void
{
  // `after` handlers are synchronous and are not provided with callbacks
  trace("Doing some things now that the context is initialized...");
}
```

For more information on message handling and managed objects see:

1. framework/readme-async
2. framework/readme-message-dispatcher
3. framework/readme-lifecycle

## Packaging A Robotlegs-Specific Extension

The source for an extension should be packaged thusly:

    src
      robotlegs
        extensions
          superDuper
            readme.md
            SuperDuperExtension (implements IContextConfig)
            api
              ISuperDuper
            impl
              SuperDuper

We can clearly spot the API, implementation and integration classes above. 

The api package should include any classes or interfaces that the typical user would come into contact with. The impl package contains classes that the typical user would not import.

## Unit Tests

The unit tests for an extension should be packaged thusly:

    test
      robotlegs
        extensions
          superDuper
            SuperDuperExtensionTest
            SuperDuperExtensionTestSuite
      			api
      			  SuperDuperErrorTest
            impl
              SuperDuperTest
            support
              SuperDuperFrequencyModulator

The ExtensionTest tests the extension integration class itself. The implementation package contains tests for implementation classes. And the TestSuite catalogs all of the test cases.

# Distributing an Extension

todo: recommend GitHub. Recommend unit tests.

robotlegs-extensions-SuperDuper

# Dev Notes

