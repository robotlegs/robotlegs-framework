# Hooks

Hooks run before or after certain extension actions.

## Hook Forms

A hook can exist in one of three forms:

* Function
* Object
* Class

### Function Hooks

A function hook is simply invoked when the time is right:

	function randomHook():void {
		trace("hooked!");
	}

### Object Hooks

An object hook is expected to expose a "hook" method:

	public class SomeHook
	{
		public function hook():void
		{
			trace("hooked!");
		}
	}

### Class Hooks

Instantiating a Class hook should result in an object that exposes a "hook" method:

	public class SomeOtherHook
	{
		[Inject] public var someModel:SomeModel;

		public function hook():void
		{
			someModel.enabled = false;
		}
	}

