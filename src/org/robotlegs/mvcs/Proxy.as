package org.robotlegs.mvcs
{
	import flash.events.Event;
	
	import org.robotlegs.core.IEventBroadcaster;
	import org.robotlegs.core.IProxy;
	
	public class Proxy implements IProxy
	{
		[Inject(name='mvcsEventBroadcaster')]
		public var eventBroadcaster:IEventBroadcaster;
		
		/**
		 * Default MVCS <code>IProxy</code> implementation
		 */
		public function Proxy()
		{
		}
		
		/**
		 * dispatchEvent Helper method
		 * The same as calling <code>dispatchEvent</code> directly on the <code>IEventBroadcaster</code>
		 * @param event The <code>Event</code> to dispatch on the <code>IEventBroadcaster</code>
		 */
		protected function dispatch(event:Event):void
		{
			eventBroadcaster.dispatchEvent(event);
		}
	
	}
}