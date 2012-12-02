//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.framework.api.IMessageDispatcher;

	/**
	 * Message Dispatcher implementation.
	 */
	public final class MessageDispatcher implements IMessageDispatcher
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _handlers:Dictionary = new Dictionary();

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
		public function dispatchMessage(message:Object, callback:Function = null, reverse:Boolean = false):void
		{
			var handlers:Array = _handlers[message];
			if (handlers)
			{
				handlers = handlers.concat();
				reverse || handlers.reverse();
				new MessageRunner(message, handlers, callback).run();
			}
			else
			{
				callback && safelyCallBack(callback);
			}
		}
	}
}

import robotlegs.bender.framework.impl.safelyCallBack;

class MessageRunner
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _message:Object;

	private var _handlers:Array;

	private var _callback:Function;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function MessageRunner(message:Object, handlers:Array, callback:Function)
	{
		_message = message;
		_handlers = handlers;
		_callback = callback;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function run():void
	{
		next();
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function next():void
	{
		// Try to keep things synchronous with a simple loop,
		// forcefully breaking out for async handlers and recursing.
		// We do this to avoid increasing the stack depth unnecessarily.
		var handler:Function;
		while (handler = _handlers.pop())
		{
			if (handler.length == 0) // sync handler: ()
			{
				handler();
			}
			else if (handler.length == 1) // sync handler: (message)
			{
				handler(_message);
			}
			else if (handler.length == 2) // sync or async handler: (message, callback)
			{
				var handled:Boolean;
				handler(_message, function(error:Object = null, msg:Object = null):void
				{
					// handler must not invoke the callback more than once
					if (handled) return;

					handled = true;
					if (error || _handlers.length == 0)
					{
						_callback && safelyCallBack(_callback, error, _message);
					}
					else
					{
						next();
					}
				});
				// IMPORTANT: MUST break this loop with a RETURN. See top.
				return;
			}
			else // ERROR: this should NEVER happen
			{
				throw new Error("Bad handler signature");
			}
		}
		// If we got here then this loop finished synchronously.
		// Nobody broke out, so we are done.
		// This relies on the various return statements above. Be careful.
		_callback && safelyCallBack(_callback, null, _message);
	}
}
