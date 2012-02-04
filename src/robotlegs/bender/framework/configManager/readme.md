# Config Manager

The config manager is responsible for installing configuration files into a context.

## Overview

A config manager is essentially just an object processor. Objects are fed into the manager and processed by object handlers.

Note: For general information on object handling see:

+ core.async.readme
+ core.messaging.readme
+ core.objectProcessor.readme

## Built-in Config Handlers

For convenience the config manager has a couple of built-in handlers:

* IContextConfig Instance Handler
* IContextConfig Class Handler
* Plain Object Handler
* Plain Class Handler

### IContextConfig Instance Handler

An IContextConfig implementation might look like this:

    public class SomeConfig implements IContextConfig
    {
        public function configureContext(context:IContext):void
        {
            trace("Configuring context: ", context);
        }
    }

An instance of that class would be installed as follows:

    context.require(new SomeConfig());    

When the instance is installed the configureContext() method on that instance is invoked immediately and supplied with a reference to a context. The default handler is very simple:

    private function handleContextConfig(config:IContextConfig):void
    {
        config.configureContext(_context);
    }

For more information on IContextConfig implementations see:

+ extensions.readme
+ bundles.readme

### IContextConfig Class Handler

A class that implements IContextConfig can be installed like so:

    context.require(SomeConfig);

The default handler simply creates a new instance of that class and installs it. The new instance will then be handled by the IContextConfig instance handler as above.

### Plain Object Handler

If the context has already been initialized the supplied object will simply be injected into.

    context.require(new SomePlainClass());

If the context is not yet initialized the object will be queued. When the context is initialized the object will be injected into.

### Plain Class Handler

If the context has already been initialized an instance of the supplied class will be instantiated using the context's injector.

    context.require(SomePlainClass);

If the context is not yet initialized the class will be queued. When the context is initialized an instance of the class will be instantiated.
