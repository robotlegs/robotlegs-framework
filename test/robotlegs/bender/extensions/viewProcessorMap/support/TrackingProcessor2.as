package robotlegs.bender.extensions.viewProcessorMap.support
{
	import org.swiftsuspenders.Injector;

	public class TrackingProcessor2 implements ITrackingProcessor
	{
		private const _processedViews:Array = [];
		private const _unprocessedViews:Array = [];

		public function process(view:Object, type:Class, injector:Injector):void
		{
			_processedViews.push(view);
		}

		public function unprocess(view:Object, type:Class, injector:Injector):void
		{
			_unprocessedViews.push(view);
		}

		public function get processedViews():Array
		{
			return _processedViews;
		}

		public function get unprocessedViews():Array
		{
			return _unprocessedViews;
		}
	}

}

