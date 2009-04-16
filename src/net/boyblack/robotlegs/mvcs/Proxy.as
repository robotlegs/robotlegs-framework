package net.boyblack.robotlegs.mvcs
{
	import flash.events.Event;

	import net.boyblack.robotlegs.core.IEventBroadcaster;
	import net.boyblack.robotlegs.core.IProxy;

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