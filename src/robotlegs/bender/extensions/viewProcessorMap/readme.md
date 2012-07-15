# View Processor Map Extension

## Overview

The view processor map provides automagic processing of mapped views landing on the stage and manual processing where preferred.

## Extension Installation

	context.extend( ViewProcessorMapExtension );
	
### Default access to the map is by injecting against the `IViewProcessorMap` interface

	[Inject]
	public var viewProcessorMap:IViewProcessorMap;

## ViewMap Usage

The Robotlegs 2 view map is designed to allow views to be 'processed', driven by the object's type (class, superclasses and interfaces). The most typical 'processor' would inject the view via inspection - and this processor is built in.

You can create your own processor, for example to do property injection without inspection, skinning, localisation and so on.

### Making mappings

You map either a specific type or a TypeMatcher to the class or instance of processor you want to be used.

	viewProcessorMap.map(SomeType).toProcessor(FastInjector);
	
	viewProcessorMap.mapMatcher(new TypeMatcher().anyOf(ISpaceShip, IRocket)).toProcessor(SpacecraftSkinner);
	
	// you can also use an instance as the processor, in this case, to avoid inspection when doing property injection
	
	viewProcessorMap.map(SomeType).toProcessor( new FastPropertyInjector( { userID:UserID, animationSettings:AnimationSettings } ) );
	
#### Shortcut method for the most common case: injection by inspection

	viewProcessorMap.map(SomeType).forInjection();
	
#### Type / Package Matching

We provide a TypeMatcher and PackageMatcher. TypeMatcher has `allOf`, `noneOf`, `anyOf`. For more complex logic (equivalent of 'or') you can simply make multiple mappings. For more details on type and package matching, see:

1. robotlegs.bender.extensions.matching.readme

#### Adding guards and hooks

You can optionally add guards and hooks:

	map(SomeClass).toProcess(LocaliseText).withGuards(NotOnTuesdays).withHooks(UpdateLog);

	// in the situation where you just want guards and hooks, and no processing needs to be done

	map(SomeClass).toNoProcess().withGuards(NotOnTuesdays).withHooks(ApplySkin, UpdateLog);
	
Guards and hooks can be passed as arrays or just a list of classes.	

Guards and hooks will be injected with the view (these injections are then cleaned up so that views are not generally available for injection).

For more information on guards and hooks check out: 

1. robotlegs.bender.framework.readme-guards
2. robotlegs.bender.framework.readme-hooks

### Creating processors

Processors need to implement two methods:

	process(view:ISkinnable, class:Class):void;
	unprocess(view:ISkinnable, class:Class):void;
	
These methods are checked by duck typing, rather than forcing you to implement an interface, so that you can use stricter typing on the view argument passed. The class is passed to avoid you having to re-inspect the object (in most cases the viewProcessorMap will already have obtained this information).
	
In many cases, `unprocess` will simply be an empty function, but some processes may need to 'clean up' - for example removing listeners and so on.

Where a processor is mapped as a class, a singleton instance will be instantiated via the injector.

In most cases, processors shouldn't be stateful with respect to the views that they handle, other than in keeping a (weak) cache of which objects have already been processed, both for the purposes of unprocessing and for not re-processing the same object.

### Removing mappings

	viewProcessorMap.unmap(SomeClass).fromProcess(FastInject);
	
	viewProcessorMap.unmapMatcher(someTypeMatcher).fromProcess(processorInstance);
	
	viewProcessorMap.unmap(SomeClass).fromProcesses();

### Processing views automatically

In Robotlegs 2, stage-event listening is centralised to a ViewManager. The ViewManager listens for views landing on the stage, and being removed from stage, and informs interested parties, such as the viewProcessorMap, accordingly.

Assuming you're listening to your contextView, any view that lands on the contextView can be processed if it matches a mapping you've already created.

### Processing objects manually

If you don't want the overhead of listening for views landing on the stage, you'll need to implement your own strategy for deciding when views should be processed and unprocessed. Map your rules as normal, and then use:

	viewProcessorMap.process(item);
	
	viewProcessorMap.unprocess(item);

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
