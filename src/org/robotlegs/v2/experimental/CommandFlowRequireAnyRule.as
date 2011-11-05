//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.experimental
{
	import flash.events.Event;

	public class CommandFlowRequireAnyRule extends CommandFlowRule
	{
		private var _requiredEvents:Vector.<String>;
	
		public function CommandFlowRequireAnyRule(eventStrings:Vector.<String>)
		{
			_requiredEvents = eventStrings;
		}
		
		override public function applyEvent(event:Event):Boolean
		{
			if(_requiredEvents.indexOf(event.type) > -1)
			{
				_receivedEvents.push(event);
				return true;
			}
			return false;
		}
	
	}

}