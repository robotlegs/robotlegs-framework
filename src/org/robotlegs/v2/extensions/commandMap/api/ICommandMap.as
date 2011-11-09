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
		function mapTrigger(trigger:ICommandTrigger):ICommandMapper;

		function mapEvent(type:String, eventClass:Class = null, once:Boolean = false):ICommandMapper;

		function unmapTrigger(trigger:ICommandTrigger):ICommandUnmapper;

		function unmapEvent(type:String, eventClass:Class = null):ICommandUnmapper;

		function getTriggerMapping(trigger:ICommandTrigger, commandClass:Class):ICommandMapping;

		function getEventMapping(type:String, eventClass:Class, commandClass:Class):ICommandMapping;
	}
}
