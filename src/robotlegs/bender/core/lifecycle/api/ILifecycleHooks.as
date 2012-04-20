package robotlegs.bender.core.lifecycle.api
{
	public interface ILifecycleHooks
	{
		function beforeInitializing(handler:Function):ILifecycleHooks;
		
		function whenInitializing(handler:Function):ILifecycleHooks;
		
		function afterInitializing(handler:Function):ILifecycleHooks;
		
		function beforeSuspending(handler:Function):ILifecycleHooks;
		
		function whenSuspending(handler:Function):ILifecycleHooks;
		
		function afterSuspending(handler:Function):ILifecycleHooks;
		
		function beforeResuming(handler:Function):ILifecycleHooks;
		
		function whenResuming(handler:Function):ILifecycleHooks;
		
		function afterResuming(handler:Function):ILifecycleHooks;
		
		function beforeDestroying(handler:Function):ILifecycleHooks;
		
		function whenDestroying(handler:Function):ILifecycleHooks;
		
		function afterDestroying(handler:Function):ILifecycleHooks;
	}
}