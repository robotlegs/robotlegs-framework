# Robotlegs Extensions

## Extensions vs Bundles

An extension integrates a single utility or library into a Robotlegs context.

A bundle bundles up a selection of extensions and configurations into a single package.

# Writing An Extension

A Robotlegs extension should contain at least four things: an API, an implementation, an integration file and a readme.

The API and implementation files define the extension or utility itself.

The integration file defines how and when the extension is loaded into (and removed from) a Robotlegs context.

The readme file is the most important. It's the first thing that you write when you sit down to build an extension. It outlines your goals, the purpose of the extension and how the extension can be used:

http://tom.preston-werner.com/2010/08/23/readme-driven-development.html

If you can't sum up what the extension is and how it can be used in a small readme file, then the scope of your extension is too big and you should consider breaking it out into smaller, more focused extensions.

## The Extension/Integration Class (IContextConfig)

An extension implements the IContextConfig interface. When included into a context, that context is immediately passed through to the configureContext() method.

    package robotlegs.extensions.superDuper
    {
      public class SuperDuperExtension implements IContextConfig
      {
        public function configureContext(context:IContext):void
        {
          trace(this, " is being installed into ", context);
          // BEWARE: the context may not yet be initialized.
        }
      }
    }

NOTE: The context instance provided to configureContext() may not be fully initialized.

### Initializing an Extension

An extension hooks into the various context life cycle phases by adding handlers when it is installed.

    public function configureContext(context:IContext):void
    {
      if (context.initialized)
      {
        throw new Error("This extension must be installed prior to context initialization");
      }
      context.addStateHandler(ManagedObject.PRE_INITIALISE, handleContextPreInitialize);
    }

// todo: finish

## Packaging a Robotlegs-Specific Extension

    robotlegs
      extensions
        superDuper
          readme.md
          SuperDuperExtension (implements IContextConfig)
          api
            ISuperDuper
          impl
            SuperDuper

We can clearly spot the API, implementation and integration classes above. The API and implementation classes are in the robotlegs.extensions namespace.

## Packaging a Non-Robotlegs-Specific Extension - Keeping the Extension Separate

    robotlegs
      extensions
        superDuper
          readme.md
          SuperDuperExtension (implements IContextConfig)

In this example the API and implementation classes are in a separate, versioned library that is not dependent on Robotlegs in any way. The extension is merely a convenient way to include and bootstrap that library in the context of a Robotlegs application/module. The extension lives on its own and does not include Robotlegs or the library itself.

## Packaging a Non-Robotlegs-Specific Extension - Bundling the Extension into the Library

    domain
      library
        integration
          robotlegs
            readme.md
            SuperDuperExtension (implements IContextConfig)

In this example the library offers Robotlegs integration by providing an Extension bundled in its own source.

# Dev Notes

