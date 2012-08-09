# Context

A context is a scope. It is core to any application or module built using Robotlegs.

## Creating a Context

To create a context simply instantiate a new Context and provide some configuration:

	_context = new Context()
        .extend(MVCSBundle)
        .configure(
            MyModuleConfig,
            view
        );

Note: you must hold on to that context reference. Failing to do so will result in the context instance being garbage collected.

In the example above we are installing a bundle, a configuration and a reference to a Display Object Container. The Display Object Container will be used as the "contextView".

The "contextView" should be provided as the final configuration as it may trigger context initialization.

# Bundles and Extensions

Most extensions and bundles can be installed as classes:

    _context.extend(MVCSBundle, InjectorLoggingExtension);

Some extensions offer some extra configuration by way of constructor arguments:

    _context.extend(new ScopedEventDispatcherExtension("shared", "local"));

# Configuration

## Class Configs

    _context.configure(MyModuleConfig);

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
            mediatorMap.map(SomeView)
                .toMediator(SomeMediator);
        }
    }

Or, if you dislike metadata:

    class MyModuleConfig
    {
        public function MyModuleConfig(mediatorMap:IMediatorMap)
        {
            mediatorMap.map(SomeView)
                .toMediator(SomeMediator);
        }
    }

Note: you will not be able to use the above config as a Flex tag due to the required constructor arguments.

Alternatively, you can implement the optional IConfig interface. If a config implements this interface `configure()` will be invoked after construction/injection:

    class MyModuleConfig implements IConfig
    {
        [Inject]
        public var mediatorMap:IMediatorMap;

        public function configure():void
        {
            mediatorMap.map(SomeView)
                .toMediator(SomeMediator);
        }
    }


## Object Configs

    _context.configure(new MyModuleConfig("hello"));

If the context has already been initialized the supplied object will simply be injected into.

If the context is not yet initialized the object will be queued. When the context is initialized the object will be injected into.

