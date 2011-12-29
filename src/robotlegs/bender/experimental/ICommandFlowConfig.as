//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.experimental
{
	public interface ICommandFlowConfig
	{
		function execute(commandClass:Class):ICommandFlowConfig;

		function executeAll(...commandClassesList):ICommandFlowConfig;
	}
}