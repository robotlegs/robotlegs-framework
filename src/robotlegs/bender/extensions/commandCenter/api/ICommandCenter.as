//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api
{
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

	/**
	 * Creates command mappings for triggers
	 */
	public interface ICommandCenter
	{
		/**
		 * Maps a trigger
		 * @param trigger The trigger to map
		 * @return Command Mapper
		 */
		function map(trigger:ICommandTrigger):ICommandMapper;

		/**
		 * Unmaps a trigger
		 * @param trigger The trigger to unmap
		 * @return Command Unmapper
		 */
		function unmap(trigger:ICommandTrigger):ICommandUnmapper;
	}
}
