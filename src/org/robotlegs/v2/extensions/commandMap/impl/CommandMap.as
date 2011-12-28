//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import flash.utils.Dictionary;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMap;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapper;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMappingFinder;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandUnmapper;

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
