//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.messaging
{

	/**
	 * The IMessageDispatcher contract.
	 */
	public interface IMessageDispatcher
	{
		/**
		 * Registers a message handler with a MessageDispatcher.
		 * @param message The interesting message
		 * @param handler The handler function
		 */
		function addMessageHandler(message:Object, handler:Function):void;

		/**
		 * Removes a message handler from a MessageDispatcher
		 * @param message The interesting message
		 * @param handler The handler function
		 */
		function removeMessageHandler(message:Object, handler:Function):void;

		/**
		 * Checks whether the MessageDispatcher has any handlers registered for a specific message.
		 * @param message The interesting message
		 * @return A value of true if a handler of the specified message is registered; false otherwise.
		 */
		function hasMessageHandler(message:Object):Boolean;

		/**
		 * Dispatches a message into the message flow.
		 * @param message The interesting message
		 * @param callback The completeion callback function
		 * @param reverse Reverse the dispatch order
		 */
		function dispatchMessage(message:Object, callback:Function = null, reverse:Boolean = false):void;

		[Deprecated(message="Don't seem to use this anywhere. Why is it here?")]
		function dispatchScopedMessage(scope:Object, message:Object, callback:Function = null, reverse:Boolean = false):void;
	}
}
