package robotlegs.bender.extensions.viewProcessorMap.support
{
	public class TrackingProcessor implements ITrackingProcessor
	{
		private const _processedViews:Array = [];
		private const _unprocessedViews:Array = [];

		public function process(view:Object, type:Class):void
		{
			_processedViews.push(view);
		}

		public function unprocess(view:Object, type:Class):void
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

