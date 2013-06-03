# View Processor Map Extension

## Overview

The view processor map provides automagic processing of mapped views landing on the stage and manual processing where preferred.

## Extension Installation

```as3
context.install( ViewProcessorMapExtension );
```

### Default access to the map is by injecting against the `IViewProcessorMap` interface

```as3
[Inject]
public var viewProcessorMap:IViewProcessorMap;
```

## ViewMap Usage

The Robotlegs 2 view map is designed to allow views to be 'processed', driven by the object's type (class, superclasses and interfaces). The most typical 'processor' would inject the view via inspection - and this processor is built in.

You can create your own processor, for example to do property injection without inspection, skinning, localisation and so on.

### Making mappings

You map either a specific type or a TypeMatcher to the class or instance of processor you want to be used.

```as3
viewProcessorMap.map(SomeType).toProcessor(FastInjector);

viewProcessorMap.mapMatcher(new TypeMatcher().anyOf(ISpaceShip, IRocket)).toProcessor(SpacecraftSkinner);

// you can also use an instance as the processor, in this case, to avoid inspection when doing property injection

viewProcessorMap.map(SomeType).toProcessor( new FastPropertyInjector( { userID:UserID, animationSettings:AnimationSettings } ) );
```

#### Shortcut method for the most common case: injection by inspection

```as3
viewProcessorMap.map(SomeType).toInjection();
```

#### Type / Package Matching

We provide a TypeMatcher and PackageMatcher. TypeMatcher has `allOf`, `noneOf`, `anyOf`. For more complex logic (equivalent of 'or') you can simply make multiple mappings. For more details on type and package matching, see:

1. robotlegs.bender.extensions.matching.readme

#### Adding guards and hooks

You can optionally add guards and hooks:

```as3
map(SomeClass).toProcess(LocaliseText).withGuards(NotOnTuesdays).withHooks(UpdateLog);

// in the situation where you just want guards and hooks, and no processing needs to be done

map(SomeClass).toNoProcess().withGuards(NotOnTuesdays).withHooks(ApplySkin, UpdateLog);
```

Guards and hooks can be passed as arrays or just a list of classes.	

Guards and hooks will be injected with the view (these injections are then cleaned up so that views are not generally available for injection).

The guards and hooks run prior to the `process` method on the processor. Processors are NOT automatically made available for injection to hooks.

In the case where you need access to the processor in a hook, pass a class rather than an instance as the process, which will then be used as a singleton and mapped for injection, and inject against the processor class (or interface) in your hook.

For more information on guards and hooks check out: 

1. robotlegs.bender.framework.readme-guards
2. robotlegs.bender.framework.readme-hooks

## Utility processors provided

## ViewInjectionProcessor

Injects view by passing it to the injector, where it will be inspected and then injected. You can access this via either of the following:

```as3
map(SomeType).toInjection();
map(SomeType).toProcess(ViewInjectionProcessor);
```

## FastPropertyInjector

Allows injection of properties (by the injector), without describing the object type. You provide names and types of injection points in the configuration object passed to the constructor.

```as3
map(ViewThatIsTooExpensiveToInspect).toProcess(new FastPropertyInjector({gravity:Gravity, bounce:Bounce}));
```

## PropertyValueInjector

Allows injection of values directly, using only property names, so that the injector is never consulted.

```as3
map(ViewNeedingQuickParams).toProcess(new PropertyValueInjector({gravity:9.8, bounce:4}));
```

## MediatorCreator

Allows you to use mediators via the viewProcessorMap - for example in the case where you want to minimise the size of the framework within your application.

```as3
map(ViewNeedingMediator).toProcess(new MediatorCreator(SomeMediator));
```

The mediator class passed should implement `set viewComponent`, `initialize` and `destroy` methods as required (only those provided will be called).

A difference between the mediatorMap and the viewProcessorMap: in the mediatorMap, mediators can be injected into hooks. In the viewProcessorMap they aren't mapped for injection at all.

### Creating custom processors

Processors need to implement two methods:

```as3
process(view:ISkinnable, class:Class, injector:IInjector):void;
unprocess(view:ISkinnable, class:Class, injector:IInjector):void;
```

These methods are checked by duck typing, rather than forcing you to implement an interface, so that you can use stricter typing on the view argument passed. The class is passed to avoid you having to re-inspect the object (in most cases the viewProcessorMap will already have obtained this information).
	
In many cases, `unprocess` will simply be an empty function, but some processes may need to 'clean up' - for example removing listeners and so on.

Where a processor is mapped as a class, a singleton instance will be instantiated via the injector.

In most cases, processors shouldn't be stateful with respect to the views that they handle, other than in keeping a (weak) cache of which objects have already been processed, both for the purposes of unprocessing and for not re-processing the same object.

The injector passed is an instance of the local injector for the map. If your processor doesn't need access to the injector and you want to avoid importing it, simply type this 3rd argument `Object` or `*`.

You may wish to use a childInjector for local mappings within the process.

### Removing mappings

```as3
viewProcessorMap.unmap(SomeClass).fromProcess(FastInject);

viewProcessorMap.unmapMatcher(someTypeMatcher).fromProcess(processorInstance);

viewProcessorMap.unmap(SomeClass).fromProcesses();
```

### Processing views automatically

In Robotlegs 2, stage-event listening is centralised to a ViewManager. The ViewManager listens for views landing on the stage, and being removed from stage, and informs interested parties, such as the viewProcessorMap, accordingly.

Assuming you're listening to your contextView, any view that lands on the contextView can be processed if it matches a mapping you've already created.

### Processing objects manually

If you don't want the overhead of listening for views landing on the stage, you'll need to implement your own strategy for deciding when views should be processed and unprocessed. Map your rules as normal, and then use:

```as3
viewProcessorMap.process(item);

viewProcessorMap.unprocess(item);
```

### Packages excluded from automatic processing

For efficiency, classes from the following packages are excluded from automatic processing:

	flash
	mx
	spark

### Flex specifics

Flex UIComponents can have their processors 'paused' until creationComplete has fired - this is something you would implement in your custom processor.

### Reparenting

When a view is reparented it fires both the remove and the added events. On remove, the view will be unprocessed. On add it will be offered to be reprocessed (if guards allow it). The default processor (the normal injector) will keep a cache of processed views (as keys in a weak Dictionary to avoid holding references that should be released), and will not reprocess them. However, guards and hooks will potentially be re-run - you can employ your own tracking/caching strategy to avoid repeating hooks that don't need to re-run.

Your own processor can employ which ever strategy makes sense to you.

### Unmapping does not equal unprocessing

Unmapping removes the rule. It will not unprocess views related to that mapping. If necessary, you'll can unprocess the views concerned manually.

### Mapping and Unmapping is robust to redundancy

- Duplicating an existing mapping, using the same guards and hooks, will not produce an error
- Unmapping a mapping that does not exist will not produce an error
- Repeating a mapping but with different guards and hooks will produce an error.
	- if you use guards or hooks that were not previously used, the error is synchronous
	- if you omit guards or hooks that were previous used, the error will happen as early as possible, which is the next time the mapping is used by the mediatorMap
	- if you omit guards or hooks and this mapping is never used again, you will never see the error (but it shouldn't matter)
