//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageCommandMap.api
{
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

	/**
	 * The Message Command Map allows you to bind Messages to Commands
	 */
	public interface IMessageCommandMap
	{
		/**
		 * Creates a mapping for a message based trigger
		 * @param message The message
		 * @return Command Mapper
		 */
		function map(message:Object):ICommandMapper;

		/**
		 * Unmaps a mappings from a message based trigger
		 * @param message The message
		 * @return Command Unmapper
		 */
		function unmap(message:Object):ICommandUnmapper;
	}
}
