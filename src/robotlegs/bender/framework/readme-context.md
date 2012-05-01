# Context

A context is a scope. It is core to any application or module built using Robotlegs.

## Creating A Context

To create a new context simply instantiate a new Context and provide some configuration:

	_context = new Context()
        .extend(MVCSBundle)
        .configure(
            MyModuleConfig,
            view
        );

Note: you must hold on to that context reference. Failing to do so will result in the context instance being garbage collected.

In the example above we are installing a bundle, a configuration and a reference to a Display Object Container.

# Extensions

    context.extend(MVCSBundle);

TODO: expand..

# Configuration

### Plain Class Configs

    context.configure(MyModuleConfig);

If the context has already been initialized an instance of the supplied class will be instantiated using the context's injector.

If the context is not yet initialized the class will be queued. When the context is initialized an instance of the class will be instantiated.

Such a config might look like this:

    class MyModuleConfig
    {
        [Inject]
        public var mediatorMap:IMediatorMap;

        [PostConstruct]
        public function init():void
        {
            mediatorMap.map().......
        }
    }

## Plain Object Configs

    context.configure(new MyModuleConfig("hello"));

If the context has already been initialized the supplied object will simply be injected into.

If the context is not yet initialized the object will be queued. When the context is initialized the object will be injected into.

