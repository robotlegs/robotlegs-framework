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
	public interface ICommandMapper
	{
		/**
		 * Creates a command mapping
		 * @param commandClass The Command Class to map
		 * @return Mapping configurator
		 */
		function toCommand(commandClass:Class):ICommandConfigurator;
	}
}
