//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api
{

	/**
	 * Represents a command trigger
	 */
	public interface ICommandTrigger
	{
		/**
		 * Adds a mapping to this trigger
		 * @param mapping The Command Mapping to add
		 */
		function addMapping(mapping:ICommandMapping):void;

		/**
		 * Removes a mapping from this trigger
		 * @param mapping The Command Mapping to remove
		 */
		function removeMapping(mapping:ICommandMapping):void;
	}
}
