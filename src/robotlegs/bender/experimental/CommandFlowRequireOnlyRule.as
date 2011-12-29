//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.experimental
{
	import flash.events.Event;
	import org.swiftsuspenders.Injector;

	public class CommandFlowRequireOnlyRule extends CommandFlowRule
	{
		private var _requiredEvent:String;

		public function CommandFlowRequireOnlyRule(eventString:String, injector:Injector)
		{
			_requiredEvent = eventString;
			super(injector);
		}

		override public function applyEvent(event:Event):Boolean
		{
			if(_requiredEvent == event.type)
			{
				_receivedEvents.push(event);
				return true;
			}
			return false;
		}

	}

}