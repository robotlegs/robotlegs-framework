//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingFinder;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

	public class CommandCenter implements ICommandCenter
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappers:Dictionary = new Dictionary();

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(trigger:ICommandTrigger):ICommandMapper
		{
			return _mappers[trigger] ||= new CommandMapper(trigger);
		}

		public function unmap(trigger:ICommandTrigger):ICommandUnmapper
		{
			return _mappers[trigger];
		}

		public function getMapping(trigger:ICommandTrigger):ICommandMappingFinder
		{
			return _mappers[trigger];
		}
	}
}
