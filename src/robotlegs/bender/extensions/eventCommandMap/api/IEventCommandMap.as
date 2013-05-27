//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.api
{
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

	/**
	 * The Event Command Map allows you to bind Events to Commands
	 */
	public interface IEventCommandMap
	{
		/**
		 * Creates a mapping for an Event based trigger
		 * @param type The Event type
		 * @param eventClass The concrete Event class
		 * @return Command Mapper
		 */
		function map(type:String, eventClass:Class = null):ICommandMapper;

		/**
		 * Unmaps an Event based trigger from a Command
		 * @param type The Event type
		 * @param eventClass The concrete Event class
		 * @return Command Unmapper
		 */
		function unmap(type:String, eventClass:Class = null):ICommandUnmapper;

		/**
		 * Adds a handler to process mappings
		 * @param handler Function that accepts a mapping
		 * @return Self
		 */
		function addMappingProcessor(handler:Function):IEventCommandMap;
	}
}
