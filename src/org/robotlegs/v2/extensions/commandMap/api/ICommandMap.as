//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.api
{

	public interface ICommandMap
	{
		function map(commandClass:Class):ICommandMapper;

		function unmap(commandClass:Class):ICommandUnmapper;

		function unmapAll(commandClass:Class):void;

		function hasMapping(commandClass:Class):Boolean;
	}
}
