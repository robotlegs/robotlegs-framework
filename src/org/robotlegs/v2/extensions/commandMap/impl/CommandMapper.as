//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import flash.utils.Dictionary;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapper;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMappingFinder;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandUnmapper;

	public class CommandMapper implements ICommandMapper, ICommandUnmapper, ICommandMappingFinder
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const mappings:Dictionary = new Dictionary();

		private var trigger:ICommandTrigger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandMapper(trigger:ICommandTrigger)
		{
			this.trigger = trigger;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function toCommand(commandClass:Class):ICommandMapping
		{
			return mappings[commandClass] ||= createMapping(commandClass);
		}

		public function fromCommand(commandClass:Class):ICommandMapping
		{
			const mapping:ICommandMapping = mappings[commandClass];
			mapping && trigger.removeMapping(mapping);
			delete mappings[commandClass];
			return mapping;
		}

		public function forCommand(commandClass:Class):ICommandMapping
		{
			return mappings[commandClass];
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMapping(commandClass:Class):ICommandMapping
		{
			const mapping:ICommandMapping = new CommandMapping(trigger.injector, commandClass);
			trigger.addMapping(mapping);
			return mapping;
		}
	}
}
