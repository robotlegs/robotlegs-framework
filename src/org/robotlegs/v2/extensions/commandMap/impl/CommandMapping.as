//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;

	public class CommandMapping implements ICommandMapping
	{

		public function CommandMapping(commandType:Class)
		{

		}

		public function toEvent(type:String, eventClass:Class = null):ICommandMapping
		{
			toTrigger(new EventCommandTrigger());
			return this;
		}

		public function toTrigger(trigger:ICommandTrigger):ICommandMapping
		{
			//return this to enable chaining
			return this;
		}
	}
}
