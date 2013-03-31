//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.api
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandUnmapper;

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
		function map(type:String, eventClass:Class = null):IEventCommandMapper;

		/**
		 * Unmaps an Event based trigger from a Command
		 * @param type The Event type
		 * @param eventClass The concrete Event class
		 * @return Command Unmapper
		 */
		function unmap(type:String, eventClass:Class = null):ICommandUnmapper;
	}
}
