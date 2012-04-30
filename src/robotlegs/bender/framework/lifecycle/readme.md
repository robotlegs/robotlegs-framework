# Lifecycle

A lifecycle provides `initialize`, `suspend`, `resume` and `destroy` methods.

A lifecycle usually refers to a specific instance. You can provide this instance when creating your lifecycle and refer to it via the read-only `target` property:

	const lifecycle:Lifecycle = new Lifecycle(someManagedObject);
	lifecycle.target // returns someManagedObject;

For most developers, the only lifecycle you are interested in will be the context's lifecycle, which is created by the context itself.

## States

A lifecycle can be in one of the following settled states:

- `UNINITIALIZED`
- `ACTIVE`
- `SUSPENDED`
- `DESTROYED`

During a transition a lifecycle can be in one of the following transitionary states:

- `INITIALIZING`
- `SUSPENDING`
- `RESUMING`
- `DESTROYING`

**Before initialization** the lifecycle is `UNINITIALIZED`. From here, only `initialize()` is a valid transition.

**During initialization** the lifecycle is `INITIALIZING`.

**Once initialized** the lifecycle becomes `ACTIVE`.

From `ACTIVE` a lifecycle can be suspended or destroyed.

From `SUSPENDED` a lifecycle can be resumed (returning it to `ACTIVE`), or destroyed.

Once `DESTROYED` there is no way back.

Invalid transitions can be captured by listening for the LifecycleEvent.ERROR event. If no listener is attached an Error will be thrown.

## Lifecycle Events

A lifecycle dispatches the following events:

- `PRE_INITIALIZE`
- `INITIALIZE`
- `POST_INITIALIZE`

- `PRE_SUSPEND`
- `SUSPEND`
- `POST_SUSPEND`

- `PRE_RESUME`
- `RESUME`
- `POST_RESUME`

- `PRE_DESTROY`
- `DESTROY`
- `POST_DESTROY`

- `ERROR`

## Hooking in to transitions

A lifecycle provides 4 transition hooks: `beforeInitializing`, `beforeSuspending`, `beforeResuming` and `beforeDestroying`.

Handlers added to these transitions are executed when the transition starts and before any events are dispatched.

A before handler must have one of the following signatures:

- `handler():void`
- `handler(message:Object):void`
- `handler(message:Object, callback:Function):void`

The message will be the state that the lifecycle is attempting to transition into.

### _Before_ handlers can block the transition

If a handler accepts a callback and calls the callback with an error, the transition will be terminated, and the state will be reverted to the pre-transition state.

For more background on async handlers in Robotlegs 2 see:

+ core.async.readme
+ core.messaging.readme

### Suspend and destroy handlers & events run backwards

The `initialize` and `resume` transitions run their handlers, and dispatch events, in the order in which they were added.

The `suspend` and `destroy` transitions run their handlers in reverse, so the last handler added to a particular transition, e.g. `beforeDestroying()`, is run first during the transition.

Likewise, listeners for `suspend` and `destroy` transitions are notified in reverse.

## Dealing with errors

There are two situations in which errors can occur

- When an invalid transition is attempted
- When a before handler calls back with an error

In both cases the lifecycle will dispatch `LifecycleEvent.ERROR` if a listener for that event has been attached, otherwise an error will be thrown.

When attempting a transition into a given state, a user callback may be supplied. If an error occurs, and a listener has been attached as explained above, the error will be supplied to the callback.

## Handlers cannot be removed

A lifecycle manages the validity of transitions - so both `initialize` and `destroy` are, via the lifecycle's internal state machine, one-time-only transitions. The only repeatable transitions are `suspend` and `resume`. If you need to 'unhook' from these transitions, we recommend you decouple your handlers and use a flag to exit-early from your handlers if the object they would deal with has been cleaned up.

	private var _managedExtension:SomeExtension;

	public function set managedExtension(value:SomeExtension):void
	{
		_managedExtension = value;
	}

	private function deactivateExtension():void
	{
		if (!_managedExtension) return;

		// code that actually does stuff here
	}

	private function activateExtension():void
	{
		if (!_managedExtension) return;

		// code that actually does stuff here
	}

	private function addContextLifecycleHooks():void
	{
		context.lifecycle
			.beforeSuspending(deactivateExtension)
			.beforeResuming(activateExtension)
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
			.beforeInitializing( checkEventDispatcherInstalled, checkEmbeddedFonts )
			.beforeSuspending( grabPauseTime, detachConsole )
			.beforeResuming( calculatePauseInterval, reattachConsole )
			.beforeDestroying( offerConsoleDump );

### For managing your own object's lifecycle

	const awesomeExtension:AwesomeExtension = new AwesomeExtension();
	const awesomeLifecycle:Lifecycle = new Lifecycle(awesomeExtension);

	// you would now need to provide an opportunity for any interested parties to add their hooks

	const callback:Function = function(errors:Object):void
	{
		// log the errors
	}

	awesomeLifecycle.initialize(callback);