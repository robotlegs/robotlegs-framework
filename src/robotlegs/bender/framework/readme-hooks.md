# Hooks

Hooks run before or after certain extension actions. They are typically used by extensions to run custom actions based on environmental conditions.

## Hook Forms

A hook can exist in one of three forms:

* Function
* Object
* Class

### Function Hooks

A function hook is simply invoked when the time is right:

```as3
function randomHook():void {
	trace("hooked!");
}
```

### Object Hooks

An object hook must expose a "hook" method:

```as3
public class SomeHook
{
	public function hook():void
	{
		trace("hooked!");
	}
}
```

The "hook" method will be called each time the hook runs. The object will not be injected into.

### Class Hooks

A class reference can be used as a hook:

```as3
public class SomeOtherHook
{
	[Inject] public var someModel:SomeModel;

	public function hook():void
	{
		someModel.enabled = false;
	}
}
```

A new object will be constructed each time the hook is run. The object will be injected into.