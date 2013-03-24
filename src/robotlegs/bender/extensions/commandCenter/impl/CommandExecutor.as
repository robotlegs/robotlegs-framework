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
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.framework.impl.applyHooks;
	import robotlegs.bender.framework.impl.guardsApprove;

	public class CommandExecutor implements ICommandExecutor
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _mappings:ICommandMappingList;

		public function set mappings(value:ICommandMappingList):void
		{
			_mappings = value;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _mapPayload:Function;

		private var _unmapPayload:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandExecutor(injector:Injector)
		{
			_injector = injector;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function withPayloadMapper(mapPayload:Function):CommandExecutor
		{
			_mapPayload = mapPayload;
			return this;
		}

		public function withPayloadUnmapper(unmapPayload:Function):CommandExecutor
		{
			_unmapPayload = unmapPayload;
			return this;
		}

		public function execute(... params):void
		{
			for (var mapping:ICommandMapping = _mappings.head; mapping; mapping = mapping.next)
			{
				var command:Object = null;

				_mapPayload && _mapPayload.apply(null, params);

				if (mapping.guards.length == 0 || guardsApprove(mapping.guards, _injector))
				{
					const commandClass:Class = mapping.commandClass;

					command = _injector
						? _injector.instantiateUnmapped(commandClass)
						: new commandClass();

					if (mapping.hooks.length > 0)
					{
						_injector && _injector.map(commandClass).toValue(command);
						applyHooks(mapping.hooks, _injector);
						_injector && _injector.unmap(commandClass);
					}
				}

				_unmapPayload && _unmapPayload.apply(null, params);

				if (command)
				{
					mapping.fireOnce && _mappings.removeMapping(mapping);
					mapping.executeMethod && command[mapping.executeMethod]();
				}
			}
		}
	}
}
