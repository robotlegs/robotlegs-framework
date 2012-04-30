//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.lifecycle.api
{
	import robotlegs.bender.core.lifecycle.impl.LifecycleState;

	public interface ILifecycle extends ILifecycleHooks
	{
		function get target():Object;

		function set invalidTransitionHandler(handler:Function):void;

		function set processErrorHandler(handler:Function):void;

		function get state():LifecycleState;

		function initialize(actionCallback:Function = null):void;

		function suspend(actionCallback:Function = null):void;

		function destroy(actionCallback:Function = null):void;

		function resume(actionCallback:Function = null):void;
	}
}
