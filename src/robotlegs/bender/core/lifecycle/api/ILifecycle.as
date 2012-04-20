package robotlegs.bender.core.lifecycle.api
{
	import robotlegs.bender.core.lifecycle.impl.LifecycleState;
	
	public interface ILifecycle extends ILifecycleHooks
	{
		function get target():Object;
		
		function set invalidTransitionHandler(handler:Function):void;
		
		function set processErrorHandler(handler:Function):void;
		
		function initialize(actionCallback:Function = null):void;
		
		function suspend(actionCallback:Function = null):void;
		
		function destroy(actionCallback:Function = null):void;
		
		function resume(actionCallback:Function = null):void;
		
		function get state():LifecycleState;
	}
}