package net.boyblack.robotlegs.mvcs
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import net.boyblack.robotlegs.core.IEventBroadcaster;

	public class EventBroadcaster implements IEventBroadcaster
	{
		protected var eventDispatcher:IEventDispatcher;

		public function EventBroadcaster( eventDispatcher:IEventDispatcher )
		{
			this.eventDispatcher = eventDispatcher;
		}

		public function dispatchEvent( event:Event ):Boolean
		{
			return eventDispatcher.dispatchEvent( event );
		}

	}
}