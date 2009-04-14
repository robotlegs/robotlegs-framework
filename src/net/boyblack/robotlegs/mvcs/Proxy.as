package net.boyblack.robotlegs.mvcs
{
	import net.boyblack.robotlegs.core.IEventBroadcaster;
	import net.boyblack.robotlegs.core.IProxy;

	public class Proxy implements IProxy
	{
		[Inject( name='mvcsEventBroadcaster' )]
		public var eventBroadcaster:IEventBroadcaster;

		public function Proxy()
		{
		}

	}
}