package net.boyblack.robotlegs.mvcs
{
	import net.boyblack.robotlegs.core.IEventBroadcaster;
	import net.boyblack.robotlegs.core.IService;

	public class Service implements IService
	{
		[Inject( name='mvcsEventBroadcaster' )]
		public var eventBroadcaster:IEventBroadcaster;

		public function Service()
		{
		}

	}
}