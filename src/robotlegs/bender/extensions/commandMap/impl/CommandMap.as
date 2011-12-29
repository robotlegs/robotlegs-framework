//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandMap.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.commandMap.api.ICommandMap;
	import robotlegs.bender.extensions.commandMap.api.ICommandMapper;
	import robotlegs.bender.extensions.commandMap.api.ICommandMappingFinder;
	import robotlegs.bender.extensions.commandMap.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandMap.api.ICommandUnmapper;

	public class CommandMap implements ICommandMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const mappers:Dictionary = new Dictionary();

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(trigger:ICommandTrigger):ICommandMapper
		{
			return mappers[trigger] ||= new CommandMapper(trigger);
		}

		public function unmap(trigger:ICommandTrigger):ICommandUnmapper
		{
			return mappers[trigger];
		}

		public function getMapping(trigger:ICommandTrigger):ICommandMappingFinder
		{
			return mappers[trigger];
		}
	}
}
