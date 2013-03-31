//------------------------------------------------------------------------------
//  Copyright (c) 2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.eventCommandMap.impl
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.api.ICommandUnmapper;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandConfigurator;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMapper;

	public class EventCommandMapper implements IEventCommandMapper, ICommandUnmapper
	{

		private var _mappings:ICommandMappingList;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function EventCommandMapper(mappings:ICommandMappingList)
		{
			_mappings = mappings;
		}

		/**
		 * @inheritDoc
		 */
		public function toCommand(commandClass:Class):IEventCommandConfigurator
		{
			const mapping:EventCommandMapping = new EventCommandMapping(commandClass);
			_mappings.addMapping(mapping);
			return mapping;
		}

		/**
		 * @inheritDoc
		 */
		public function fromCommand(commandClass:Class):void
		{
			_mappings.removeMappingFor(commandClass);
		}

		/**
		 * @inheritDoc
		 */
		public function fromAll():void
		{
			_mappings.removeAllMappings();
		}
	}
}
