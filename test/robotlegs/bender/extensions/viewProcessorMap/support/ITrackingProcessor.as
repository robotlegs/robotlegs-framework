package robotlegs.bender.extensions.viewProcessorMap.support
{

	public interface ITrackingProcessor
	{
		function process(view:Object, type:Class):void;
		
		function unprocess(view:Object, type:Class):void;
	}

}

