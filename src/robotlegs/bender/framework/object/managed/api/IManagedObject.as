//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.object.managed.api
{
	import robotlegs.bender.core.stateMachine.api.IStateMachine;

	public interface IManagedObject extends IStateMachine
	{
		function get object():Object;

		function get initializing():Boolean;

		function get initialized():Boolean;

		function get destroying():Boolean;

		function get destroyed():Boolean;

		function initialize(callback:Function = null):void;

		function destroy(callback:Function = null):void;
	}
}
