//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.experimental
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Injector;

	public class CommandFlowRequireAllRule extends CommandFlowRule
	{
		private const _requiredAndReceivedEvents:Dictionary = new Dictionary();
		
		private static const EVENT_NOT_RECEIVED:String = "eventNotReceived";
	
		public function CommandFlowRequireAllRule(eventStrings:Vector.<String>, injector:Injector)
		{
			populateRequiredEvents(eventStrings);
			super(injector);
		}
		
		override public function applyEvent(event:Event):Boolean
		{
			if(_requiredAndReceivedEvents[event.type])
			{
				_requiredAndReceivedEvents[event.type] = event;
				return checkAllEventsReceived();
			}
			return false;
		}
		
		override public function get receivedEvents():Vector.<Event>
		{
			const lastEventsReceived:Vector.<Event> = new <Event>[];
			
			for each (var event:Event in _requiredAndReceivedEvents)
			{
				lastEventsReceived.push(event);
			}
			
			return lastEventsReceived;
		}
		
		private function populateRequiredEvents(eventStrings:Vector.<String>):void
		{
			for each (var eventType:String in eventStrings)
			{
				_requiredAndReceivedEvents[eventType] = EVENT_NOT_RECEIVED;
			}
		}
	
		private function checkAllEventsReceived():Boolean
		{
			for (var p:String in _requiredAndReceivedEvents)
			{
				if(_requiredAndReceivedEvents[p] == EVENT_NOT_RECEIVED)
					return false;
			}
			return true;
		}
	}
}