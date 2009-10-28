package org.robotlegs.mvcs.support
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class TestContextViewMediator extends Mediator
	{
		public static const MEDIATOR_IS_REGISTERED:String = "MediatorIsRegistered";
		
		public function TestContextViewMediator()
		{
			super();
		}
		
		override public function onRegister() : void
		{
			eventDispatcher.dispatchEvent(new Event(MEDIATOR_IS_REGISTERED));
		}
	}
}