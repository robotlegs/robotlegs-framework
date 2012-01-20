//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandMap.dsl
{

	public interface ICommandMappingFinder
	{
		function forCommand(commandClass:Class):ICommandMappingConfig;
	}
}
