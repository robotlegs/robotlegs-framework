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
		function map(commandType:Class):ICommandMapping;
		function unmap(commandType:Class):void;
		function hasMapping(commandType:Class):Boolean;
	}
}
