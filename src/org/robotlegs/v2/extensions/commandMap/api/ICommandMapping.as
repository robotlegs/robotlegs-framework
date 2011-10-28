//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.api
{
	public interface ICommandMapping
	{
		function toEvent(type:String, eventClass:Class=null):ICommandMapping;
		function toTrigger(trigger:ICommandTrigger):ICommandMapping;
	}
}