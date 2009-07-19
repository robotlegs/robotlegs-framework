package org.robotlegs.mvcs
{
	import flash.events.Event;

	import org.robotlegs.core.IEventBroadcaster;
	import org.robotlegs.core.IProxy;

	public class Proxy implements IProxy
	{
		[Inject( name='mvcsEventBroadcaster' )]
		public var eventBroadcaster:IEventBroadcaster;

		public function Proxy()
		{
		}

		protected function dispatch( event:Event ):void
		{
			eventBroadcaster.dispatchEvent( event );
		}

	}
}