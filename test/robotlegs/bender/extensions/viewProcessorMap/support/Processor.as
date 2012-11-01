package robotlegs.bender.extensions.viewProcessorMap.support
{
	public class Processor
	{
		[Inject(name='timingTracker')]
		public var timingTracker:Array;

		public function process(view:*, type:Class, injector:*):void
		{
			timingTracker.push(Processor);
		}

		public function unprocess(view:*, type:Class, injector:*):void
		{

		}
	}

}

