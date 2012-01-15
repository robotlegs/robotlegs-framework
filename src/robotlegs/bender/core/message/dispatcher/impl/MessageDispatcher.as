//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.message.dispatcher.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.core.async.safelyCallBack;
	import robotlegs.bender.core.message.dispatcher.api.IMessageDispatcher;

	public final class MessageDispatcher implements IMessageDispatcher
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _handlers:Dictionary = new Dictionary();

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MessageDispatcher()
		{
			// todo: some concept of a "source" like EventDispatcher?
			// how would anyone access that?
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
				// todo: validate handler for (message) and (message, callback)
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
			// note: code duplication to avoid increasing the stack depth unnecessarily
			if (_handlers[message])
			{
				// note: list is cloned and reversed because elements are popped
				const handlers:Array = _handlers[message].concat();
				reverse || handlers.reverse();
				next(message, handlers, callback);
			}
			else
			{
				callback && safelyCallBack(callback);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispatchScopedMessage(scope:Object, message:Object, callback:Function = null, reverse:Boolean = false):void
		{
			// note: code duplication to avoid increasing the stack depth unnecessarily
			if (_handlers[scope])
			{
				// note: list is cloned and reversed because elements are popped
				const handlers:Array = _handlers[scope].concat();
				reverse || handlers.reverse();
				next(message, handlers, callback);
			}
			else
			{
				callback && safelyCallBack(callback);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		/**
		 * Helper method to dispatch to a handler in one of the 3 handler forms:
		 *
		 * (), (message), (message, callback)
		 *
		 * @param message The message being dispatched
		 * @param handlers The list of handlers that need to be called
		 * @param callback The eventual callback
		 */
		private function next(message:Object, handlers:Array, callback:Function):void
		{
			// Try to keep things synchronous with a simple loop,
			// forcefully breaking out for async handlers and recursing.
			// We do this to avoid increasing the stack depth unnecessarily.
			var handler:Function;
			while (handler = handlers.pop())
			{
				if (handler.length == 0) // sync handler: ()
				{
					handler();
				}
				else if (handler.length == 1) // sync handler: (message)
				{
					handler(message);
				}
				else if (handler.length == 2) // sync or async handler: (message, callback)
				{
					var handled:Boolean;
					handler(message, function(error:Object = null, msg:Object = null):void
					{
						// handler must not invoke the callback more than once 
						if (handled)
							return;

						handled = true;

						if (error || handlers.length == 0)
						{
							callback && safelyCallBack(callback, error, message);
						}
						else
						{
							next(message, handlers, callback);
						}
					});
					// IMPORTANT: MUST break this loop with a RETURN. See above.
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
			callback && safelyCallBack(callback, null, message);
		}
	}
}
