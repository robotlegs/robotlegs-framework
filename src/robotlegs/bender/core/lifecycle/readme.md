# Lifecycle

A lifecycle providing `initialize`, `suspend`, `resume` and `destroy` methods.

A lifecycle usually refers to a specific instance. You can pass this instance when creating your Lifecycle and refer to it via the read-only `target` property:

	var lifecycle:Lifecycle = new Lifecycle(someManagedObject);
	lifecycle.target // returns someManagedObject;
	
For most developers, the only lifecycle you are interested in will be the context's lifecycle, which is created by the context itself.	
	
## Overview

A lifecycle can be in any of the following states:

- `UNBORN`
- `BORN`
- `ACTIVE`
- `SUSPENDED`
- `DESTROYED`

**Before initialization**, the Lifecycle is `UNBORN`. From here, only `initialize` is a valid transition.

**Once initialized**, the Lifecycle becomes `ACTIVE` (the `BORN` state is _passed through_ during initialization, and a Lifecycle will only be stuck in the `BORN` state if an error prevented initialization.)

From `ACTIVE` a Lifecycle can be suspended or destroyed.

From `SUSPENDED` a Lifecycle can be resumed (returning it to `ACTIVE`), or destroyed. In `SUSPENDED`, further calls to `SUSPENDED` will do nothing, but will not produce an error.

Once `DESTROYED` there is no way back. Further calls to `DESTROYED` will do nothing, but will not produce an error.

Invalid transitions can be captured by adding a handler to the `lifecycle.invalidTransitionHandler` property. This handler will be passed a string describing the transition that was attempted.

## Hooking in to transitions

The Lifecycle provides 4 distinct hooks: `before`, `when` and `after` any transition, and a `callback`, passed to the transition function itself, which runs between the _when_ and _after_ hooks.

For clarity, the ordering is:

1. _Before_ transitioning handlers run
2. If there are no errors, the state is changed, if there are errors the callback passed to the transition is run, and the errors are passed to it, and we go no further
3. _When_ transitioning handlers run
4. The _callback_ passed to the transition is run
5. _After_ transitioning handlers run

A complete list of the process timing hooks:

	beforeInitializing
	whenIntitializing
	afterIntializing
	
	beforeSuspending
	whenSuspending
	afterSuspending
	
	beforeResuming
	whenResuming
	afterResuming
	
	beforeDestroying
	whenDestroying
	afterDestroying

Timing hooks can be chained, as they return the same interface that you use to access them.

### Wait, do we really need 4 different hooks?

Each of the 4 hooks provides a particular way to hook into the transition.

- `before` hooks can **block** the transition from happening.
- `when` hooks are **non-blocking**, and run after the state has changed, but before the callback passed to the transition is run.
- `after` hooks are **non-blocking**, and run after the callback passed to the transition is run.

The callback passed to the transition can process the errors from the _before_ handlers, and runs whether or not the transition is made. The _when_ and _after_ hooks only run if the transition is successful (i.e. there are no _before_ handler errors).

### Suspend and destroy handlers run backwards

The `initialize` and `resume` transitions run their handlers in the order in which they were added. The `suspend` and `destroy` transitions run their handlers in reverse, so the last handler added to a particular phase, e.g. `whenDestroying`, is run first during that phase.

### _Before, when_ and _after_ hooks persist, callbacks are one-time

A handler added to `beforeSuspending` will be run every time the lifecycle is suspended. A callback passed to `suspend()` will run once only, unless you pass the same callback to the `suspend()` function when you run it again at a later time.

### _Before, when_ and _after_ handlers can receive a message and a process callback

Your _before, when_ and _after_ handlers should have one of the following signatures:

- `handler():void`
- `handler(message:Object):void`
- `handler(message:Object, callback:Function):void`

The message will be a LifecycleMessage, and offers access to the follow properties:

- `target` : the target object passed to this Lifecycle instance when it was created (optional)
- `transition` : the transition function that was called, one of `instance.initialize, instance.suspend, instance.resume, instance.destroy`
- `timing` : one of `Lifecycle.BEFORE, Lifecycle.WHEN, Lifecycle.AFTER`
- `description` : a string describing the transition and timing, eg "when initializing"

A handler receiving the callback is asynchronous, and the message dispatching chain will be interrupted until it calls back.

For more background on async handlers in Robotlegs 2 see:

+ core.async.readme
+ core.messaging.readme

### _Before_ handlers can block the transition

If your *before* handler passes anything (but ideally an `Error`) to the callback, the transition will be halted. No further *before* handlers will run.

### *When* and *after* handlers cannot block the transition

If a *when* or *after* handler passes anything (including an `Error`) to the callback, the transition will proceed, and all the errors during each phase (*when* or *after*) will be gathered.

## Dealing with handler errors

### Dealing with all handler errors using the `processErrorHandler` property

Set the `processErrorHandler` property to a function that will handle errors returned by handlers during *before*, *when* and *after* phases.

This function should have one of the following signatures:

- handler(errors:Object):void
- handler(errors:Object, lifecycleMessage:LifecycleMessage):void

The LifecycleMessage offers access to the follow properties:

- `target` : the target object passed to this Lifecycle instance when it was created (optional)
- `transition` : the transition function that was called, one of `instance.initialize, instance.suspend, instance.resume, instance.destroy`
- `timing` : one of `Lifecycle.BEFORE, Lifecycle.WHEN, Lifecycle.AFTER`
- `description` : a string describing the transition and timing, eg "when initializing"

The purpose of the LifecycleMessage is to allow you to log and debug errors. Switching using LifecycleMessage properties in order to run real processes is not advised.

The errors Object will usually be an array of errors that were encountered.

If both *when* and *after* handlers returned errors, the `processErrorHandler` will be run twice - once for each phase of the transition.

### Dealing with *before* handler errors using the transition callback

Any errors passed back from the *before* handlers will result in the transition not being run and the errors being passed to the transition callback. The *before* process is blocking, so you will only receive the first error that was returned by a handler.

### If you fail to deal with errors, the process will explode

If you don't set a `processErrorHandler`, errors returned by the *when* and *after* handlers will cause a LifecycleError to be thrown. If you really want to ignore them, use an empty function as the handler. 

In the case of *before* handler errors, these can be dealt with by your callback (the function passed to `initialize(callback)`, for example), or by the `processErrorHandler`, or by both. If you don't provide a callback and you haven't set a `processErrorHandler`, an error will be thrown.

You cannot typically catch this error as the process is asynchronous.

## Handlers cannot be removed

The Lifecycle manages the validity of transitions - so both `initialize` and `destroy` are, via the Lifecycle's internal state machine, one-time-only transitions. The only repeatable transitions are `suspend` and `resume`. If you need to 'unhook' from these transitions, we recommend you decouple your handlers and use a flag to exit-early from your handlers if the object they would deal with has been cleaned up.

	private var _managedExtension:SomeExtension;
	
	public function set managedExtension(value:SomeExtension):void
	{
		_managedExtension = value;
	}

	private function deactivateExtension(message:Object, callback:Function):void
	{
		if(!_managedExtension) return;
		
		// code that actually does stuff here
	}
	
	private function activateExtension(message:Object, callback:Function):void
	{
		if(!_managedExtension) return;
		
		// code that actually does stuff here
	}
	
	private function addContextLifecycleHooks():void
	{
		context.lifecycle
			.whenSuspending(deactivateExtension)
			.whenResuming(activateExtension)
	}

If the whole Lifecycle is no longer required, just null it out, and any handlers will be released for garbage collection.

## Errors are, by design, non-recoverable

The purpose of error reporting in the lifecycle is to debug **during development**, not to recover run-time problems. When you make use of the lifecycle, your handlers should be returning errors only on the basis of non-mutable properties: problems that were cemented at compile time, not problems that can occur only at runtime such as network availability issues, order of operations, data entry screw ups and so on.

In the case of an error in your `initialize()` process, the next step would be to study that error and make relevant changes in your code base, and then recompile. For this reason it's critical that extension developers write very helpful error messages.

#### Good reasons for a lifecycle handler to return an error:

- The correct range of fonts wasn't embedded
- An extension on which this extension depends hasn't been installed
- The code is running in a sandbox that doesn't have the permissions this extension requires
- An essential configuration object hasn't been created (e.g. developer credentials for a licensed extension)
- Couldn't load a module containing critical extension dependencies - e.g. an engine

#### Poor reasons for a lifecycle handler to return an error:

- Lost contact with the network
- User doesn't have an account
- Couldn't load a module containing non-critical extension dependencies - e.g. a skin

## What kind of object might have a lifecycle?

Most developers will only encounter the lifecycle attached to the context.

Remember - lifecycle errors are non-recoverable. Their purpose is to provide detailed and meaningful explosions during development in order to ensure that the developer has included all the dependencies and configuration requirements of this extension.

Normal run-time errors should be dealt with in the usual ways, not through lifecycles. It is highly unlikely that providing a service with a lifecycle would be a good approach. 

An extension framework - for example an entity system - might have its own lifecycle to allow other extensions to hook in to its lifecycle phases (particularly suspend / resume).

## Basic Usage 

### For extensions accessing the context's own lifecycle:

An example usage, for an imaginary extension which provides a developer console to the application.

    context.lifecycle
			.beforeInitializing( checkEventDispatcherInstalled )
			.beforeInitializing( checkEmbeddedFonts )
			.whenInitializing( setLocalDateTime )
			.whenInitializing( setLocalPaths )
			.whenSuspending( grabPauseTime )
			.afterSuspending( deactivateConsole )
			.whenResuming( calculatePauseInterval )
			.afterResuming( reactivateConsole )
			.beforeDestroying( offerConsoleDump )
			.afterDestroying( destroyConsole );
			
	context.lifecycle.processEventHandler = logProcessErrors;
	context.lifecycle.invalidTransitionHandler = debugInvalidTransition;

### For managing your own object's lifecycle

	const awesomeExtension:AwesomeExtension = new AwesomeExtension();
	const awesomeLifecycle:Lifecycle = new Lifecycle(awesomeExtension);
	
	// you would now need to provide an opportunity for any interested parties to add their hooks
	
	const callback:Function = function(errors:Object):void
	{
		// log the errors
	}

	awesomeLifecycle.initialize(callback);