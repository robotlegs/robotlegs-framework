//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
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
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _mappings:ICommandMappingList;

		private var _injector:Injector;

		private var _mapPayload:Function;

		private var _unmapPayload:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandExecutor(mappings:ICommandMappingList, injector:Injector)
		{
			_mappings = mappings;
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

		public function execute():void
		{
			const list:Vector.<ICommandMapping> = _mappings.getList();
			const length:int = list.length;
			for (var i:int = 0; i < length; i++)
			{
				var mapping:ICommandMapping = list[i];
				var command:Object = null;

				_mapPayload && _mapPayload(mapping);

				if (mapping.guards.length == 0 || guardsApprove(mapping.guards, _injector))
				{
					const commandClass:Class = mapping.commandClass;
					mapping.fireOnce && _mappings.removeMapping(mapping);

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

				_unmapPayload && _unmapPayload(mapping);

				if (command)
				{
					mapping.executeMethod && command[mapping.executeMethod]();
				}
			}
		}
	}
}
