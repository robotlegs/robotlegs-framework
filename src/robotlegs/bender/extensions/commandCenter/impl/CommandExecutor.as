//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.framework.impl.applyHooks;
	import robotlegs.bender.framework.impl.guardsApprove;

	public class CommandExecutor implements ICommandExecutor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _removeMapping:Function;

		private var _handleResult:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandExecutor(
			injector:Injector,
			removeMapping:Function = null,
			handleResult:Function = null)
		{
			_injector = injector;
			_removeMapping = removeMapping;
			_handleResult = handleResult;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function executeCommands(mappings:Vector.<ICommandMapping>, payload:CommandPayload = null):void
		{
			const length:int = mappings.length;
			for (var i:int = 0; i < length; i++)
			{
				executeCommand(mappings[i], payload);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function executeCommand(mapping:ICommandMapping, payload:CommandPayload = null):void
		{
			const hasPayload:Boolean = payload && payload.hasPayload();
			const injectionEnabled:Boolean = hasPayload && mapping.payloadInjectionEnabled;
			var command:Object = null;

			injectionEnabled && mapPayload(payload);

			if (mapping.guards.length == 0 || guardsApprove(mapping.guards, _injector))
			{
				const commandClass:Class = mapping.commandClass;
				mapping.fireOnce && _removeMapping && _removeMapping(mapping);
				command = _injector.instantiateUnmapped(commandClass);
				if (mapping.hooks.length > 0)
				{
					_injector.map(commandClass).toValue(command);
					applyHooks(mapping.hooks, _injector);
					_injector.unmap(commandClass);
				}
			}

			injectionEnabled && unmapPayload(payload);

			if (command && mapping.executeMethod)
			{
				const executeMethod:Function = command[mapping.executeMethod];
				const result:* = (hasPayload && executeMethod.length > 0)
					? executeMethod.apply(null, payload.values)
					: executeMethod();
				_handleResult && _handleResult(result, command, mapping);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function mapPayload(payload:CommandPayload):void
		{
			var i:uint = payload.length;
			while (i--)
			{
				_injector.map(payload.classes[i]).toValue(payload.values[i]);
			}
		}

		private function unmapPayload(payload:CommandPayload):void
		{
			var i:uint = payload.length;
			while (i--)
			{
				_injector.unmap(payload.classes[i]);
			}
		}
	}
}
