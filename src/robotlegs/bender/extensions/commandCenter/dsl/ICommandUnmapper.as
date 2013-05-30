//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.dsl
{

	/**
	 * @private
	 */
	public interface ICommandUnmapper
	{
		/**
		 * Unmaps a Command
		 * @param commandClass Command to unmap
		 */
		function fromCommand(commandClass:Class):void;

		/**
		 * Unmaps all commands from this trigger
		 */
		function fromAll():void;
	}
}
