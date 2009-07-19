package org.robotlegs.mvcs
{
	import flash.events.Event;

	import org.robotlegs.core.IEventBroadcaster;
	import org.robotlegs.core.IService;

	public class Service implements IService
	{
		[Inject( name='mvcsEventBroadcaster' )]
		public var eventBroadcaster:IEventBroadcaster;

		public function Service()
		{
		}

		protected function dispatch( event:Event ):void
		{
			eventBroadcaster.dispatchEvent( event );
		}

	}
}