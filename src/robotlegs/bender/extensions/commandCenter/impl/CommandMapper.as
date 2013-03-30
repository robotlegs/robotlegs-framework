//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.api.ICommandConfigurator;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.api.ICommandUnmapper;

	public class CommandMapper implements ICommandMapper, ICommandUnmapper
	{
		private var _mappings:ICommandMappingList;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function CommandMapper(mappings:ICommandMappingList)
		{
			_mappings = mappings;
		}

		/**
		 * @inheritDoc
		 */
		public function toCommand(commandClass:Class):ICommandConfigurator
		{
			const mapping:CommandMapping = new CommandMapping(commandClass);
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
