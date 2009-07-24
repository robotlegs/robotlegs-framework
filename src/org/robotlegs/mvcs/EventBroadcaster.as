package org.robotlegs.mvcs
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.core.IEventBroadcaster;
	
	public class EventBroadcaster implements IEventBroadcaster
	{
		protected var eventDispatcher:IEventDispatcher;
		
		/**
		 * A one-way <code>IEventDispatcher</code> wrapper
		 * This is useful for contextual actors who should never listen for events but need to dispatch them
		 * @param eventDispatcher The <code>IEventDispatcher</code> to wrap
		 */
		public function EventBroadcaster(eventDispatcher:IEventDispatcher)
		{
			this.eventDispatcher = eventDispatcher;
		}
		
		/**
		 * Dispatch an <code>Event</code>
		 * @param event The <code>Event</code> to dispatch
		 * @return
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}
	
	}
}