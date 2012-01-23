//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.messaging
{

	public interface IMessageDispatcher
	{
		// todo: consider options for oneShot/once
		function addMessageHandler(message:Object, handler:Function):void;

		function removeMessageHandler(message:Object, handler:Function):void;

		function hasMessageHandler(message:Object):Boolean;

		function dispatchMessage(message:Object, callback:Function = null, reverse:Boolean = false):void;

		[Deprecated(message="Don't seem to use this anywhere. Why is it here?")]
		function dispatchScopedMessage(scope:Object, message:Object, callback:Function = null, reverse:Boolean = false):void;
	}
}
