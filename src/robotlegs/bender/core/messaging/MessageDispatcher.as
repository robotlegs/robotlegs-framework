//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.messaging
{
	import flash.utils.Dictionary;
	import robotlegs.bender.core.async.safelyCallBack;

	/**
	 * Message Dispatcher implementation.
	 */
	public final class MessageDispatcher implements IMessageDispatcher
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const HALT_ON_ERROR:uint = 1;

		public static const REVERSE:uint = 2;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _handlers:Dictionary = new Dictionary();

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MessageDispatcher()
		{
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function addMessageHandler(message:Object, handler:Function):void
		{
			const messageHandlers:Array = _handlers[message];
			if (messageHandlers)
			{
				if (messageHandlers.indexOf(handler) == -1)
					messageHandlers.push(handler);
			}
			else
			{
				_handlers[message] = [handler];
			}
		}

		/**
		 * @inheritDoc
		 */
		public function hasMessageHandler(message:Object):Boolean
		{
			return _handlers[message];
		}

		/**
		 * @inheritDoc
		 */
		public function removeMessageHandler(message:Object, handler:Function):void
		{
			const messageHandlers:Array = _handlers[message];
			const index:int = messageHandlers ? messageHandlers.indexOf(handler) : -1;
			if (index != -1)
			{
				messageHandlers.splice(index, 1);
				if (messageHandlers.length == 0)
					delete _handlers[message];
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispatchMessage(message:Object, callback:Function = null, flags:uint = 0):void
		{
			const handlers:Array = _handlers[message];
			if (handlers)
			{
				new MessageRunner(message, handlers, callback, flags).run();
			}
			else
			{
				callback && safelyCallBack(callback);
			}
		}
	}
}
