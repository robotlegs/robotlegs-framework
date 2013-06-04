//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api
{

	/**
	 * @private
	 */
	public interface ICommandExecutor
	{
		/**
		 * Execute a command for a given mapping
		 * @param mapping The Command Mapping
		 * @param payload The Command Payload
		 */
		function executeCommand(mapping:ICommandMapping, payload:CommandPayload = null):void;

		/**
		 * Execute a list of commands for a given list of mappings
		 * @param mappings The Command Mappings
		 * @param payload The Command Payload
		 */
		function executeCommands(mappings:Vector.<ICommandMapping>, payload:CommandPayload = null):void;
	}
}
