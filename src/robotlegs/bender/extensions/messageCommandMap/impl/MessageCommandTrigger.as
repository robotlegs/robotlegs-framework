//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageCommandMap.impl
{
	import flash.utils.describeType;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.impl.safelyCallBack;
	import robotlegs.bender.framework.api.IMessageDispatcher;
	import robotlegs.bender.extensions.commandMap.api.ICommandMapping;
	import robotlegs.bender.extensions.commandMap.api.ICommandTrigger;
	import robotlegs.bender.framework.impl.guardsApprove;
	import robotlegs.bender.framework.impl.applyHooks;

	public class MessageCommandTrigger implements ICommandTrigger
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>;

		private var _injector:Injector;

		private var _dispatcher:IMessageDispatcher;

		private var _message:Object;

		private var _once:Boolean;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MessageCommandTrigger(
			injector:Injector,
			dispatcher:IMessageDispatcher,
			message:Object,
			once:Boolean = false)
		{
			_injector = injector.createChildInjector();
			_dispatcher = dispatcher;
			_message = message;
			_once = once;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addMapping(mapping:ICommandMapping):void
		{
			verifyCommandClass(mapping);
			_mappings.push(mapping);
			if (_mappings.length == 1)
				addHandler();
		}

		public function removeMapping(mapping:ICommandMapping):void
		{
			const index:int = _mappings.indexOf(mapping);
			if (index != -1)
			{
				_mappings.splice(index, 1);
				if (_mappings.length == 0)
					removeHandler();
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function verifyCommandClass(mapping:ICommandMapping):void
		{
			if (describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0)
				throw new Error("Command Class must expose an execute method");
		}

		private function addHandler():void
		{
			_dispatcher.addMessageHandler(_message, handleMessage);
		}

		private function removeHandler():void
		{
			_dispatcher.removeMessageHandler(_message, handleMessage);
		}

		private function handleMessage(message:Object, callback:Function):void
		{
			const mappings:Vector.<ICommandMapping> = _mappings.concat().reverse();
			next(mappings, callback);
		}

		private function next(mappings:Vector.<ICommandMapping>, callback:Function):void
		{
			// Try to keep things synchronous with a simple loop,
			// forcefully breaking out for async handlers and recursing.
			// We do this to avoid increasing the stack depth unnecessarily.
			var mapping:ICommandMapping;
			while (mapping = mappings.pop())
			{
				if (guardsApprove(mapping.guards, _injector))
				{
					_once && removeMapping(mapping);
					_injector.map(mapping.commandClass).asSingleton();
					const command:Object = _injector.getInstance(mapping.commandClass);
					const handler:Function = command.execute;
					applyHooks(mapping.hooks, _injector);
					_injector.unmap(mapping.commandClass);

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
							if (handled)
								return;

							handled = true;

							if (error || mappings.length == 0)
							{
								callback && safelyCallBack(callback, error, _message);
							}
							else
							{
								next(mappings, callback);
							}
						});
						// IMPORTANT: MUST break this loop with a RETURN. See above.
						return;
					}
					else // ERROR: this should NEVER happen
					{
						// we swallow this and let the message processing continue
					}
				}
			}

			// If we got here then this loop finished synchronously.
			// Nobody broke out, so we are done.
			// This relies on the various return statements above. Be careful.
			callback && safelyCallBack(callback, null, _message);
		}
	}
}
