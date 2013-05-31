# Mediator Map Extension

## Overview

The mediator map provides automagic mediator creation for mapped views landing on the stage, as well as a hook for other utilities to create mediators for non-view objects, triggered in whatever manner suits them.

## Extension Installation

This extension is already installed in the MVCS bundle, but if you're not using that:

```as3
context.install(MediatorMapExtension);
```

### Default access to the map is by injecting against the `IMediatorMap` interface

```as3
[Inject]
public var mediatorMap:IMediatorMap;
```

## MediatorMap Usage

The Robotlegs 2 mediatorMap is designed to support _co-variant_ mediation. This means that multiple mediators can be mediating on behalf of one object, and that the combination of mediators created is driven by the object's type (class, superclasses and interfaces).

### Making mappings

You map either a specific type or a TypeMatcher to the mediator class you want to be created.

```as3
mediatorMap.map(SomeType).toMediator(SomeMediator);

mediatorMap.mapMatcher(new TypeMatcher().anyOf(ISpaceShip, IRocket)).toMediator(SpaceCraftMediator);
```

We provide a TypeMatcher and PackageMatcher. TypeMatcher has `allOf`, `noneOf`, `anyOf`. For more complex logic (equivalent of 'or') you can simply make multiple mappings. For more details on type and package matching, see:

1. robotlegs.bender.extensions.matching.readme

You can optionally add guards and hooks:

```as3
map(SomeClass).toMediator(SomeMediator)
	.withGuards(NotOnTuesdays)
	.withHooks(ApplySkin, UpdateLog);
```

Guards and hooks can be passed as arrays or just a list of classes.	

Guards will be injected with the view to be mediated, and hooks can be injected with both the view and the mediator (these injections are then cleaned up so that mediators are not generally available for injection).

For more information on guards and hooks check out: 

1. robotlegs.bender.framework.readme-guards
2. robotlegs.bender.framework.readme-hooks

### Removing mappings

```as3
mediatorMap.unmap(SomeClass).fromMediator(SomeMediator);

mediatorMap.unmapMatcher(someTypeMatcher).fromMediator(SomeMediator);

mediatorMap.unmap(SomeClass).fromMediators();
```

### Mediating views automatically

In Robotlegs 2, stage-event listening is centralised to a ViewManager. The ViewManager listens for views landing on the stage, and being removed from stage, and informs interested parties, such as the mediatorMap, accordingly.

Assuming you're listening to your contextView, any view that lands on the contextView can be mediated if it matches a mapping you've already created.

### Mediating objects manually

The mediatorMap is able to mediate non-view objects. However, you'll need to implement your own strategy for deciding when these objects should be mediated and unmediated. Map your rules as normal, and then use:

```as3
mediatorMap.mediate(item);

mediatorMap.unmediate(item);
```

### Packages excluded from automatic mediation

For efficiency, classes from the following packages are excluded from automatic mediation:

	flash
	mx
	spark

### Flex specifics

Flex UIComponents will have their mediators 'paused' until creationComplete has fired.

### Reparenting

When a view is reparented it fires both the remove and the added events. The mediator will be destroyed and then recreated. Any guards will be reapplied, and hooks will run again. You can guard against this situation in your hooks if it is potentially a problem (by keeping a cache of skinned views or checking some property on the view).

### Unmapping does not equal unmediating

Unmapping removes the rule. It will not destroy existing mediators related to that mapping. To remove mediators as well you'll need to unmediate the objects concerned manually.

### Mapping and Unmapping is robust to redundancy

- Duplicating an existing mapping, using the same guards and hooks, will not produce an error
- Unmapping a mapping that does not exist will not produce an error
- Repeating a mapping but with different guards and hooks will produce an error.
	- if you use guards or hooks that were not previously used, the error is synchronous
	- if you omit guards or hooks that were previous used, the error will happen as early as possible, which is the next time the mapping is used by the mediatorMap
	- if you omit guards or hooks and this mapping is never used again, you will never see the error (but it shouldn't matter)

## Mediators

### Extend, follow convention, or bake your own

Mediators should observe one of the following forms:

1. Extend the base mediator class and override `initialize` and, if needed, `destroy`.
	- If you override `destroy`, don't forget to call `super.destroy()` as this is where event listening cleanup is triggered.
2. Don't extend the base mediator class, and provide functions `initialize()` and, if needed, also `destroy()`.
3. Don't follow this convention, and use the `[PostConstruct]` metadata tag to ensure your initialization function is run
	- note that this approach is not tailored for views extending Flex UIComponent, where initialization should be deferred until after creationComplete, so you will need to either provide for this in your implementation or use one of the methods above.	

#### Example Mediators

A mediator that extends the MVCS Mediator might look like this:

```as3
public class UserProfileMediator extends Mediator
{
    [Inject]
    public var view:UserProfileView;

    override public function initialize():void
    {
        // Redispatch the event to the framework
        addViewListener(UserEvent.SIGN_IN, dispatch);
    }
}
```

You do not have to extend the MVCS mediator:

```as3
public class UserProfileMediator
{
    [Inject]
    public var view:UserProfileView;

    [Inject]
    public var dispatcher:IEventDispatcher;

    public function initialize():void
    {
        view.addEventListener(UserEvent.SIGN_IN, dispatcher.dispatch);
    }

    public function destroy():void
    {
        view.removeEventListener(UserEvent.SIGN_IN, dispatcher.dispatch);
    }
}
```

Notice that we could not use the handy "addViewListener" sugar. Also, we now need to manually clean up any listeners we have attached.

### Mediator base class provides some useful functionality

Mediator base class provides the following internal API, used for managing listeners and dispatching events.

```as3
addViewListener(eventString:String, listener:Function, eventClass:Class = null):void

addContextListener(eventString:String, listener:Function, eventClass:Class = null):void

removeViewListener(eventString:String, listener:Function, eventClass:Class = null):void

removeContextListener(eventString:String, listener:Function, eventClass:Class = null):void

dispatch(event:Event):void
```

You can also access the injected `eventMap` directly, for example to listen to a subcomponent.

For more details on the local eventMap see:

1. robotlegs.bender.extensions.localEventMap.readme
