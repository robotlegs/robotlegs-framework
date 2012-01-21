# Context

A context is a scope. It is core to any application or module built using Robotlegs.

## Creating A Context

To create a new context simply instantiate Context and provide some configuration:

	_context = new Context(
		ClassicRobotlegsBundle,
		MyModuleConfig,
		view);

Note: you must hold on to that context reference. Failing to do so will result in the context being garbage collected.

In the example above we are installing a bundle, a configuration and a reference to a Display Object Container.

For more information on configuration see:

* framework.config.manager
* extensions
* bundles