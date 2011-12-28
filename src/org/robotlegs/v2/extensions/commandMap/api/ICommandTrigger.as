//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.api
{
	import org.swiftsuspenders.Injector;

	public interface ICommandTrigger
	{
		function get injector():Injector;

		function addMapping(mapping:ICommandMapping):void;

		function removeMapping(mapping:ICommandMapping):void;
	}
}
