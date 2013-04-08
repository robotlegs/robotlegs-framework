//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api
{
	import robotlegs.bender.extensions.commandCenter.dsl.IOnceCommandConfig;
	import robotlegs.bender.extensions.commandCenter.impl.CommandPayload;

	public interface ICommandCenter
	{
		function configureCommand(commandClass:Class):IOnceCommandConfig;

		function executeCommand(commandClassOrConfig:*, payload:CommandPayload = null):ICommandMapping;

		function executeCommands(commandClassesOrConfigs:Array, payload:CommandPayload = null):Vector.<ICommandMapping>;

		function detain(command:Object):void;

		function release(command:Object):void;
	}
}
