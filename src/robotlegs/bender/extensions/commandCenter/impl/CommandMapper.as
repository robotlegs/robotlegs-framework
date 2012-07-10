//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingConfig;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingFinder;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

	public class CommandMapper implements ICommandMapper, ICommandMappingFinder, ICommandUnmapper
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Dictionary = new Dictionary();

		private var _trigger:ICommandTrigger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandMapper(trigger:ICommandTrigger)
		{
			_trigger = trigger;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function toCommand(commandClass:Class):ICommandMappingConfig
		{
			return _mappings[commandClass] ||= createMapping(commandClass);
		}

		public function forCommand(commandClass:Class):ICommandMappingConfig
		{
			return _mappings[commandClass];
		}

		public function fromCommand(commandClass:Class):void
		{
			const mapping:ICommandMapping = _mappings[commandClass];
			mapping && _trigger.removeMapping(mapping);
			delete _mappings[commandClass];
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMapping(commandClass:Class):CommandMapping
		{
			const mapping:CommandMapping = new CommandMapping(commandClass);
			_trigger.addMapping(mapping);
			return mapping;
		}
	}
}
